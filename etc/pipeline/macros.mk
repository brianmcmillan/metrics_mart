################################################################################
# Macros - etc/pipeline/macros.mk                                              #
################################################################################
define test_dir
	@# tests the directory in the <dependency>
	@#<target>(colon)(space)<path/to/directory> 
	@[[ -d $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" 
endef

define test_file
	@# tests the file in the <target>
	@#<target>(colon)(space)<path/to/directory> 
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 
endef

define test_file_warning
	@# tests the file in the <target>. If missing log [WARNING]
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $(NAME)     \"testing for $@ did not find $@\" 
endef

define test_dependent_file
	@# tests the file in the <first dependency>
	@[[ -f $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $@     \"testing for $< did not find $<\" 
endef

define file_compare
	@# tests the files in <first dependency> <second dependency>
	@cmp -s $(word 1,$^) $(word 2,$^) \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@     \"$(word 1,$^) is not the same as $(word 2,$^)\" 
endef

define record_count_csv
	@#metrics/<csv_file.csv>(colon)(space)PATH = "<path/to/file.csv>"
	@#record_count_csv: EXPECTED=<total row count>
	@#metrics/<csv_file.csv>(colon)(space)
	@[[ $(shell wc -l < $(PATH)) == $(EXPECTED) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"record count $(PATH) is $(shell wc -l < $(PATH)) not $(EXPECTED)\"  
endef

define update_file_modified_date
	@touch $< \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Updating file modification date for $< to $(shell date -r $< +"%Y-%m-%dT%H:%M:%SZ") \" 
endef

define split_csv
	@#<split/file_group_description>(colon)(space) TARGETDIR=path/to/target_directory
	@#<split/file_group_description>(colon)(space) TARGETNAME=file_name_
	@#<split/file_group_description>(colon)(space) SPLITSIZE=number_of_rows
	@#<split/file_group_description>(colon)(space) path/to/source_file.csv
	@mkdir -p $(TARGETDIR)
	@$(SPLIT) -d -a 3 -l $(SPLITSIZE) --additional-suffix=".csv" $< $(TARGETDIR)$(TARGETNAME) \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Splitting file $< by $(SPLITSIZE) lines\" 
	@$(test-dependent-file)
endef

define extract_csv_from_excel
	@#<path/to/csv_file.csv>(colon)(space)TABNAME = "<name of XLS worksheet>"
	@#<path/to/csv_file.csv>(colon)(space)<path/to/source/excel_file.xlsx>
	@$(IN2CSV) -f xlsx --sheet $(TABNAME) $< > tmp/$(basename $(<F)).tmp
	@cat tmp/$(basename $(<F)).tmp | awk -v OFS=',' '{if (NR==1) {print "source_line_number", "provider_code", "load_dts", $$0}}' > $@	
	@(awk -v OFS=',' -v date="$$(date -u +"%Y-%m-%dT%H:%M:%SZ")" -v source=$<::$(TABNAME) '{if (NR!=1) { print NR, source, date, $$0 }}' tmp/$(basename $(<F)).tmp) >> $@
	@rm -f tmp/$(basename $(<F)).tmp
	@$(test-file)
endef








define test_table
	@#test_table/<table_name>(colon)
	@if ! test $(@F) = $(shell $(SQLITE3) $(DBFILE) ".tables $(@F)" ".quit"); \
	then echo [FAIL] - $(@F) table does not exist; \
	else true; fi
endef

define test_database
	@#test_databse(colon)(space)<path/to/database.db>
	@echo $(DTS)    [INFO] - DB $(shell $(SQLITE3) $< ".databases")
endef

define record_count_table
	@#record_count/<table name>(colon)(space)<path/to/database.db>
	echo $(DTS)     [INFO] - record count = $(shell $(SQLITE3) $< \
	"SELECT COUNT(*) || ' records in $(@F).$(notdir $<)' FROM [$(@F)]" ".quit")
endef





define execute_sql_export_csv
	@#<path/to/export_file.csv>(colon)(space)<path/to/query.sql>
	@echo $(DTS)     [INFO] - Executing $< and exporting to $@
	@$(SQL2CSV) --db sqlite:///$(DBFILE) $< > $@
endef

define load_csv_into_database
	@#load_csv/SRC_<csv_file_name>_001(colon)(space)DBNAME=<database_name>
	@#load_csv/SRC_<csv_file_name>_001(colon)(space)<path/to/csv_file.csv>
	@echo $(DTS)    [INFO] - Executing $@
	@$(CSVSQL) \
	--db sqlite:///$(DBFILE) \
	--create-if-not-exists --overwrite \
	--no-inference --no-constraints \
	--chunk-size 10000 \
	--tables $(@F) \
	--insert $<
endef

define create_table
	@#<table_name>(colon)(space)<path/to/<table_name>_create.sql>
	@echo $(DTS)    [INFO] - Creating table $@
	@$(SQLITE3) $(DBFILE) ".read $<" ".quit"
endef

define execute_sql
	@#<table_name>(colon)(space) <path/to/sql_file.sql> [<dependent_table_name(s)>]
	@echo $(DTS)    [INFO] - Executing $<
	@$(SQLITE3) $(DBFILE) ".read $<" ".quit"
endef

define vega_report_from_api
	@#<path/to/export_file.html>(colon)(space)VIZTITLE=<report title>
	@#<path/to/export_file.html>(colon)(space)VIZTEMPLATE=<path/to/viz_template.vega>
	@#<path/to/export_file.html>(colon)(space)VIZURL=<path/to/viz_url.json?_shape=array>
	@#<path/to/export_file.html>(colon)(space)<source_table_name>
	@echo $(DTS)     [INFO] - Executing $@
	@cat etc/app/vega_embed_header.viz > $@
	@echo "\"data\":{\"url\":\"$(VIZURL)\"}, " >> $@
	@echo "\"title\":\"$(VIZTITLE)\"," >> $@
	@cat $(VIZTEMPLATE) >> $@
	@cat etc/app/vega_embed_footer.viz >> $@
endef

define vega_report_from_file
	@#<path/to/export_file.html>(colon)(space)VIZTITLE=<report title>
	@#<path/to/export_file.html>(colon)(space)VIZTEMPLATE=<path/to/viz_template.vega>
	@#<path/to/export_file.html>(colon)(space)<source_file_name>
	@echo $(DTS)     [INFO] - Executing $@
	@cat etc/app/vega_embed_header.viz > $@
	@echo "\"data\":{ \"values\":" >> $@
	@cat $< >> $@ && echo "}, " >> $@
	@echo "\"title\":\"$(VIZTITLE)\"," >> $@
	@cat $(VIZTEMPLATE) >> $@
	@cat etc/app/vega_embed_footer.viz >> $@
endef

define table_metadata
	@#table_metadata(colon)(space)<path/to/database.db>"
	@echo $(DTS)    [INFO] - Executing $@
	@$(SQLITE3) $(<) "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $(<) "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $(<) --save
	@$(SQLITE3) $(<) "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"
endef

define sql_template_from_csv
	@#make template/src_from_csv CSVPATH=<path/to/file.csv>
	@echo $(DTS)    [INFO] - Creating script for SRC_$(notdir $(basename $(CSVPATH)))_###_create from $(CSVPATH)
	@if test -s $(CSVPATH); then echo [PASS] - $(CSVPATH) file exists; \
	else echo [FAIL] - $(CSVPATH) file does not exist; fi
	@$(SQLITE3) tmp/temp.db ".import --csv $(CSVPATH) SRC_$(notdir $(basename $(CSVPATH)))_###"
	@$(SQLITE3) tmp/temp.db ".schema SRC_$(notdir $(basename $(CSVPATH)))_###"
	@echo "--etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql" \
	> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@echo "-------------------------------------------------------------------------------" \
	>> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@$(SQLITE3) tmp/temp.db ".schema SRC_$(notdir $(basename $(CSVPATH)))_###" \
	>> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@rm tmp/temp.db
endef

define er_diagram
	@#<path/to/diagram.type>(colon)(space)REL_FILE="<path/to/relationship_file.txt>"
	@#<path/to/diagram.type>(colon)(space)<table_name(s)>"
	@#Types can be er, pdf, png, dot
	@echo $(DTS)    [INFO] - Executing $@
	@$(ERALCHEMY) -i sqlite:///$(DBFILE) -o tmp/$(@F).er
	@cat tmp/$(@F).er $(REL_FILE) > tmp/$(@F)_2.er || true
	@$(ERALCHEMY) -i tmp/$(@F)_2.er -o $@
	@rm -f tmp/$(@F)*.er
endef

define log_rotate
	@#log_rotate:(colon)(space)<path/to/logfile>
	@echo $(DTS)    [INFO] - Executing $@
	@mv $< $(basename($<))_$(shell date +%Y-%m-%d).txt
endef

define compact_database
	@#compact_database(colon)(space)<path/to/database.db>
	@echo $(DTS)    [INFO] - Executing $@
	@$(SQLITE3) $< "PRAGMA optimize;" && echo $(DTS)    [INFO] - Optimizing database
	@$(SQLITE3) $< "PRAGMA auto_vacuum;" && echo $(DTS)    [INFO] - Vacuuming database
	@$(SQLITE3) $< "PRAGMA integrity_check;" && echo $(DTS)    [INFO] - Performing integrity check
endef

define help
	@echo $(DTS)    [INFO] - Executing $@
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

