################################################################################
# Macros - etc/pipeline/macros.mk                                              #
################################################################################
define test-dir
	@# tests the directory in the <dependency>
	@#<target>(colon)(space)<path/to/directory> 
	@[[ -d $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" 
endef

define test-file
	@# tests the file in the <target>
	@#<target>(colon)(space)<path/to/directory> 
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 
endef

define test-file-warning
	@# tests the file in the <target>. If missing log [WARNING]
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $(NAME)     \"testing for $@ did not find $@\" 
endef

define test-dependent-file
	@# tests the file in the <first dependency>
	@[[ -f $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [WARNING]    $@     \"testing for $< did not find $<\" 
endef

define file-compare
	@# tests the files in <first dependency> <second dependency>
	@cmp -s $(word 1,$^) $(word 2,$^) \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@     \"$(word 1,$^) is not the same as $(word 2,$^)\" 
endef

define record-count-csv
	@#metrics/<csv_file.csv>(colon)(space)PATH = "<path/to/file.csv>"
	@#record_count_csv: EXPECTED=<total row count>
	@#metrics/<csv_file.csv>(colon)(space)
	@[[ $(shell wc -l < $(PATH)) == $(EXPECTED) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"record count $(PATH) is $(shell wc -l < $(PATH)) not $(EXPECTED)\"  
endef

define update-file-modified-date
	@touch $< \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Updating file modification date for $< to $(shell date -r $< +"%Y-%m-%dT%H:%M:%SZ") \" 
endef

define split-csv
	@#<split/file_group_description>(colon)(space) TARGETDIR=path/to/target_directory
	@#<split/file_group_description>(colon)(space) TARGETNAME=file_name_
	@#<split/file_group_description>(colon)(space) SPLITSIZE=number_of_rows
	@#<split/file_group_description>(colon)(space) path/to/source_file.csv
	@mkdir -p $(TARGETDIR)
	@$(SPLIT) -d -a 3 -l $(SPLITSIZE) --additional-suffix=".csv" $< $(TARGETDIR)$(TARGETNAME) \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Splitting file $< by $(SPLITSIZE) lines\" 
	@$(test-dependent-file)
endef

define extract-csv-from-excel
	@#<path/to/csv_file.csv>(colon)(space)TABNAME = "<name of XLS worksheet>"
	@#<path/to/csv_file.csv>(colon)(space)<path/to/source/excel_file.xlsx>
	@$(IN2CSV) -f xlsx --sheet $(TABNAME) $< > tmp/$(basename $(<F)).tmp
	@cat tmp/$(basename $(<F)).tmp | awk -v OFS=',' '{if (NR==1) {print "source_line_number", "provider_code", "load_dts", $$0}}' > $@	
	@(awk -v OFS=',' -v date="$$(date -u +"%Y-%m-%dT%H:%M:%SZ")" -v source=$<::$(TABNAME) '{if (NR!=1) { print NR, source, date, $$0 }}' tmp/$(basename $(<F)).tmp) >> $@
	@rm -f tmp/$(basename $(<F)).tmp
	@$(test-file)
endef

define load-csv-into-db-overwrite
	@#load-<csv file>-<database>(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#load-<csv file>-<database>(colon)(space)TABLE=<table_name>
	@#load-<csv file>-<database>(colon)(space)path/to/<csv_file.csv>
	@$(CSVSQL) \
	--db sqlite:///$(DBFILEPATH) \
	--create-if-not-exists --overwrite \
	--no-inference --no-constraints \
	--chunk-size 10000 \
	--tables $(TABLE) \
	--insert $<
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Loading $< into $(DBFILEPATH)::$(SRC_TABLE)\" 
endef

define load-csv-into-db-append
	@#load-<csv file>-<database>(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#load-<csv file>-<database>(colon)(space)TABLE=<table_name>
	@#load-<csv file>-<database>(colon)(space)<path/to/csv_file.csv>
	@$(CSVSQL) \
	--db sqlite:///$(DBFILEPATH) \
	--create-if-not-exists \
	--no-inference --no-constraints \
	--chunk-size 10000 \
	--tables $(TABLE) \
	--insert $<
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Loading $< into $(DBFILEPATH)::$(SRC_TABLE)\" 
endef

define test-database
	@#test-<database.db>(colon)(space)<path/to/database.db>
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"DB $< exists - $(shell $(SQLITE3) $< ".databases")\"
endef

define test-table
	@#test-<table_name>(colon)(space)TABLENAME=<table_name>
	@#test-<table_name>(colon)(space)<path/to/database.db>
	@[[ $(shell $(SQLITE3) $< ".tables $(TABLE)" ".quit") == $(TABLE) ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Table $(TABLE) exists\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Table $(TABLE) not found\" 
endef

define record-count-table
	@#record-count-<table name>(colon)(space)TABLENAME=<table_name>
	@#record-count-<table name>(colon)(space)<path/to/database.db>
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"$(shell $(SQLITE3) $< \
	"SELECT COUNT(*) || ' records in $<::$(TABLE)' FROM [$(TABLE)]" ".quit")\"
endef

#define create-table
#	@#create-<table_name>(colon)(space)DBFILEPATH=<path/to/database_name.db>
#	@#create-<table_name>(colon)(space)TABLENAME=<table_name>
#	@#create-<table_name>(colon)(space)<path/to/<table_name>_create.sql> [<path/to/database.db>]
#	@$(SQLITE3) $(DBFILEPATH) ".read $<" ".quit"
#	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created table $(TABLE) in $(DBFILEPATH)\"
#endef

define execute-sql
	@#create-<table_name>(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#create-<table_name>(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>]
	@$(SQLITE3) $(DBFILEPATH) ".read $<" ".quit"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< on $(DBFILEPATH)\"
endef

define export-csv
	@#path/to/extract.csv(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#path/to/extract.csv(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>]
	@$(SQL2CSV) --db sqlite:///$(DBFILEPATH) $< > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< exported to $@\"
endef

define export-json
	@#path/to/extract.csv(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#path/to/extract.csv(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>] .FORCE
	$(SQLITEUTILS) $(DBFILEPATH) "$(shell cat $<)" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< exported to $@\"
endef

define export-json-nl
	@#path/to/extract.csv(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#path/to/extract.csv(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>] .FORCE
	$(SQLITEUTILS) --nl $(DBFILEPATH) "$(shell cat $<)" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< exported to $@\"
endef

define er-diagram
	@#<path/to/diagram.type>(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#<path/to/diagram.type>(colon)(space)REL_FILE="<path/to/relationship_file.txt>"
	@#<path/to/diagram.type>(colon)(space)<table_name(s)>"
	@#Types can be er, pdf, png, dot
	@$(ERALCHEMY) -i sqlite:///$(DBFILEPATH) -o tmp/$(subst .,,$(notdir $(DBFILEPATH))).er
	@cat tmp/$(subst .,,$(notdir $(DBFILEPATH))).er $(REL_FILE) > tmp/$(subst .,,$(notdir $(DBFILEPATH)))_2.er || true
	@$(ERALCHEMY) -i tmp/$(subst .,,$(notdir $(DBFILEPATH)))_2.er -o $@
	@rm -f tmp/$(subst .,,$(notdir $(DBFILEPATH)))*.er
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed er-digram and exported to $@\"
endef

define table_metadata
	@#table-metadata(colon)(space)<path/to/database.db>"
	@$(SQLITE3) $< "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $< "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $< --save
	@$(SQLITE3) $< "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $@ on $<	\"
endef

define compact-database
	@#compact-database(colon)(space)<path/to/database.db>
	@$(SQLITE3) $< "PRAGMA optimize;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Optimized $<\"
	@$(SQLITE3) $< "PRAGMA auto_vacuum = FULL;" && $(SQLITE3) $< "VACUUM;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Vacuumed $<\"
	@$(SQLITE3) $< "PRAGMA integrity_check;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Performed integrity check on $<\"
endef

define backup-database
	@#backup-database(colon)(space)BACKUPFILEPATH=<path/to/database.bak>
	@#backup-database(colon)(space)<path/to/database.db>
	@$(SQLITE3) $< ".backup $(BACKUPFILEPATH)"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Backed up $< into $(BACKUPFILEPATH)\"
endef

define log_rotate
	@#log_rotate:(colon)(space)LOGFILEPATH=<path/to/logfile>
	@#log_rotate:(colon)(space)<dependencies>
	@mv $(LOGFILEPATH) $(basename $(LOGFILEPATH))_$(shell date +%Y-%m-%d).log
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Rotated $(LOGFILEPATH) into $(basename $(LOGFILEPATH))_$(shell date +%Y-%m-%d).txt\"
endef

#define help
# Moved into main makefile
#	@echo $(DTS)    [INFO] - Executing $@
#	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
#	awk 'BEGIN {FS = ":.*?## "};\
#	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
#endef

define directory-listing
	@#<path/to/directory_listing.txt>(colon)(space).FORCE
	@$(TREE) --prune > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created directory list at $@\"
endef	

define makefile-graph
	@#<path/to/makefile_graph.png>(colon)(space).FORCE
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tpng > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created makefile diagram at $@\"
endef

define ping-test
	@#<name-of-test>(colon)(space)URL=<URL to be tested>
	@#<name-of-test>(colon)(space)[.FORCE]	
	@$(if $(shell curl $(strip $(URL)) -fIs | head -n 1), \
	echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"$(strip $(URL)) - $(shell curl $(strip $(URL)) -fIs | head -n 1), \
	echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"$(strip $(URL)) is unavailable)\"
endef	

define load-test-report
	@#<path/to/output/file.txt>(colon)(space)URL=<URL to be tested>
	@#<path/to/output/file.txt>(colon)(space)PARAMETERS="-n 100 -c 10" <n=number of iterations>, c=<concurrent connections>
	@#<path/to/output/file.txt>(colon)(space).FORCE
	@ab $(PARAMETERS) -g $(basename $@).tmp $(URL) > $(basename $@)_$(shell date +%Y-%m-%d).txt
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created report at $@\"
endef	

define load-test-metrics
	@#<path/to/output/file.csv>(colon)(space)URL=<URL to be tested>
	@#<path/to/output/file.csv>(colon)(space)PARAMETERS="-n 100 -c 10" <n=number of iterations>, c=<concurrent connections>
	@#<path/to/output/file.csv>(colon)(space).FORCE
	@#Source Header: starttime=Date Timestamp,	(6)seconds=UNIX timestamp, (7)ctime=connection_time_ms, (8)dtime=processing_time_ms, (9)ttime=total_time_ms, (10)wait=wait_time_ms
	@#Use: histogram or pareto of total_time_ms (ttime)
	@ab $(PARAMETERS) -g $(basename $@).tmp $(URL)
	@echo "provider_code,load_dts,resource_code,resource_qualifier,metric_code,metric_dts,metric_value" > $(basename $@)_$(shell date +%Y-%m-%dT%H:%M:%S).csv
	@gawk -v OFS=',' '{if (NR!=1) { print "$@",strftime("%Y-%m-%dT%H:%M:%S%z"),"$(URL)","\"ab " $(PARAMETERS) " $(URL)\"", "connection_time_ms",strftime("%Y-%m-%dT%H:%M:%S%z",$$6), $$7 }}' $(basename $@).tmp >> $(basename $@)_$(shell date +%Y-%m-%dT%H:%M:%S).csv
	@gawk -v OFS=',' '{if (NR!=1) { print "$@",strftime("%Y-%m-%dT%H:%M:%S%z"),"$(URL)","\"ab " $(PARAMETERS) " $(URL)\"", "processing_time_ms",strftime("%Y-%m-%dT%H:%M:%S%z",$$6), $$8 }}' $(basename $@).tmp >> $(basename $@)_$(shell date +%Y-%m-%dT%H:%M:%S).csv
	@gawk -v OFS=',' '{if (NR!=1) { print "$@",strftime("%Y-%m-%dT%H:%M:%S%z"),"$(URL)","\"ab " $(PARAMETERS) " $(URL)\"", "total_time_ms",strftime("%Y-%m-%dT%H:%M:%S%z",$$6), $$9 }}' $(basename $@).tmp >> $(basename $@)_$(shell date +%Y-%m-%dT%H:%M:%S).csv
	@gawk -v OFS=',' '{if (NR!=1) { print "$@",strftime("%Y-%m-%dT%H:%M:%S%z"),"$(URL)","\"ab " $(PARAMETERS) " $(URL)\"", "wait_time_ms",strftime("%Y-%m-%dT%H:%M:%S%z",$$6), $$10 }}' $(basename $@).tmp >> $(basename $@)_$(shell date +%Y-%m-%dT%H:%M:%S).csv
	@rm -f $(basename $@).tmp
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created discrete metric file at $(basename $@)_$(shell date +%Y-%m-%dT%H:%M:%S).csv\"
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
