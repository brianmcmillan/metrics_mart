################################################################################
# Unit Tests - etc/pipeline/unit_tests.mk                                      #
################################################################################
#unit-tests: mock-uninstalldirs mock-data test-macro

.PHONY: mock-file_001.csv mock-file_002.csv mock-file_003.csv mock-file_003a.csv \
mock-file_004.csv mock-file_004.xlsx mock-file_004.xlsx mock-logfile.log


mock-uninstalldirs: ##Uninstall mack data sets
	@rm -rf etc/test/* tmp/*

#### Data Mocks ####
mock-data: mock-file_001.csv mock-file_002.csv mock-file_003.csv mock-file_003a.csv \
mock-file_004.csv mock-file_004.xlsx mock-file_004.xlsx mock-logfile.log

mock-file_001.csv: PATH=etc/test/file_001.csv
mock-file_001.csv: .FORCE
	@echo "text,date,value" > $(PATH) 
	@echo "One,2021-11-08T21:00:00Z,1.00" >> $(PATH) 

mock-file_002.csv: PATH=etc/test/file_002.csv
mock-file_002.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "Two,2021-11-08T22:00:00Z,2.00" >> $(PATH) 

mock-file_003.csv: PATH=etc/test/file_003.csv
mock-file_003.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "Three,2021-11-08T23:00:00Z,3.00" >> $(PATH) 

mock-file_003a.csv: PATH=etc/test/file_003a.csv
mock-file_003a.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "Three,2021-11-08T23:00:00Z,3.00" >> $(PATH) 	

mock-file_004.csv: PATH=etc/test/file_004.csv
mock-file_004.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "One,2021-11-08T21:00:00Z,1.00" >> $(PATH) 
	@echo "Two,2021-11-08T22:00:00Z,2.00" >> $(PATH) 
	@echo "Three,2021-11-08T23:00:00Z,3.00" >> $(PATH) 

mock-file_004.xlsx: SOURCE=etc/test/file_004.base64
mock-file_004.xlsx: TARGET=etc/test/file_004.xlsx
mock-file_004.xlsx: .FORCE
	@echo "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" > $(SOURCE)
	@/usr/bin/base64 -d -i $(SOURCE) -o $(TARGET)
	@rm $(SOURCE)

mock-logfile.log: PATH=etc/test/logfile.log
mock-logfile.log: .FORCE
	@echo "2021-12-14T20:13:40Z [INFO] table-metadata "Executed table-metadata on etc/test/test.db"" > $(PATH) 
	@echo "2021-12-14T20:13:40Z [INFO] etc/test/er-diagram.pdf "Executed er-digram and exported to etc/test/er-diagram.pdf"" >> $(PATH) 
	@echo "2021-12-14T20:13:41Z [INFO] compact-database "Optimized etc/test/test.db"" >> $(PATH) 


#### SQL Mocks ####
etc/test/FILE_005_001_create.sql:
	@echo "CREATE TABLE \"FILE_005_001\" ("  > $@ 
	@echo "source_line_number VARCHAR," >> $@
	@echo "provider_code VARCHAR," >> $@
	@echo "load_dts VARCHAR," >> $@ 
	@echo "text VARCHAR," >> $@ 
	@echo "date VARCHAR," >> $@ 
	@echo "value VARCHAR);" >> $@ 

etc/test/FILE_005_001_query_001.sql: 
	@echo "SELECT * FROM SRC_file_005_001;" > $@

etc/test/er_relationships.txt:
	@echo "SRC_file_005_001 1--1 SRC_file_005_002" > $@

#### Macro tests ####
test-macro: \
test-dir-pass test-dir-fail test-dir test-dir-macro \
etc/test/file_001.csv etc/test/file_001b.csv etc/test/file_001c.csv \
etc/test/file_002.csv etc/test/file_003.csv test-dependent-file file-compare-pass \
file-compare-fail file-compare-macro record-count-csv update-file-modified-date-macro \
split-file_004 etc/test/file_005.csv \
load-csv-into-db-overwrite load-csv-into-db-append \
test-database test-table record-count-table execute-sql \
etc/test/FILE_005_001_query_001.csv etc/test/load/FILE_005_001_query_001.json etc/test/load/FILE_005_001_query_001_nl.json \
table-metadata etc/test/er-diagram.pdf compact-database backup-database log-rotate \
etc/test/directory_listing.txt etc/test/makefile_graph.png \
etc/test/load-test-report-google.txt etc/test/load-test-metrics-google.csv ping-test-pass ping-test-fail

.PHONY: test-dir-pass test-dir-fail etc1/ test-dir test-dir-macro \
test-dependent-file file-compare-pass file-compare-fail file-compare-macro record-count-csv \
update-file-modified-date update-file-modified-date-macro split-file_004 \
load-csv-into-db-overwrite load-csv-into-db-append test-database test-table \
record-count-table execute-sql makefile-list help-makefile table-metadata \
compact-database backup-database log-rotate ping-test-pass ping-test-fail

test-dir-pass: etc/
	@[[ -d $< ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"testing for $< found $?\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" 

test-dir-fail: etc1/
	@[[ -d $< ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< found $?\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"testing for $</ did not find $?\" 

test-dir: etc/
	@[[ -d $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" 

test-dir-macro: etc/
	$(test-dir)

etc/test/file_001.csv: NAME = test-file_pass
etc/test/file_001.csv: mock-file_001.csv
	@[[ -f $@ ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $(NAME)     \"testing for $@ found $@\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 

etc/test/file_001b.csv: NAME = test-file_fail
etc/test/file_001b.csv: 
	@[[ -f $@ ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $@ found $@\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $(NAME)     \"testing for $@ did not find $@\" 

etc/test/file_001c.csv: NAME = test-file_warning
etc/test/file_001c.csv: 
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $(NAME)     \"testing for $@ did not find $@\" 

etc/test/file_002.csv: NAME = test-file
etc/test/file_002.csv: mock-file_002.csv
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 

etc/test/file_003.csv: NAME = test-file_macro
etc/test/file_003.csv: mock-file_003.csv
	$(test-file)

test-dependent-file: etc/test/file_001.csv
	@[[ -f $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@     \"testing for $< did not find $<\" 

file-compare-pass: etc/test/file_003.csv etc/test/file_003a.csv
	@cmp -s $(word 1,$^) $(word 2,$^) \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@     \"$(word 1,$^) is not the same as $(word 2,$^)\" 

file-compare-fail: etc/test/file_002.csv etc/test/file_003.csv
	@cmp -s $(word 1,$^) $(word 2,$^) \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@     \"$(word 1,$^) is not the same as $(word 2,$^)\" 

file-compare-macro: etc/test/file_003.csv etc/test/file_003a.csv
	@$(file-compare)

record-count-csv: PATH=etc/test/file_004.csv
record-count-csv: EXPECTED=4
record-count-csv: mock-file_004.csv
	@[[ $(shell wc -l < $(PATH)) == $(EXPECTED) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"record count $(PATH) is $(shell wc -l < $(PATH)) not $(EXPECTED)\"  

update-file-modified-date: etc/test/file_004.csv
	@date -r $< +"%Y-%m-%dT%H:%M:%SZ" 
	@touch $<
	@date -r $< +"%Y-%m-%dT%H:%M:%SZ" 

update-file-modified-date-macro: etc/test/file_004.csv
	@touch $< \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Updating file modification date for $< to $(shell date -r $< +"%Y-%m-%dT%H:%M:%SZ")\" 

#split-csv
split-file_004: TARGETDIR=etc/test/load/$@/
split-file_004: TARGETNAME=$(basename $(<F))_
split-file_004: SPLITSIZE=2
split-file_004: etc/test/file_004.csv
	@mkdir -p $(TARGETDIR)
	@$(SPLIT) -d -a 3 -l $(SPLITSIZE) --additional-suffix=".csv" $< $(TARGETDIR)$(TARGETNAME) \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Splitting file $< by $(SPLITSIZE) lines\" 
	@$(test-dependent-file)

#extract_csv_from_excel
etc/test/file_005.csv: TABNAME = "file_004"
etc/test/file_005.csv: etc/test/file_004.xlsx
	@$(IN2CSV) -f xlsx --sheet $(TABNAME) $< > tmp/$(basename $(<F)).tmp
	@cat tmp/$(basename $(<F)).tmp | awk -v OFS=',' '{if (NR==1) {print "source_line_number", "provider_code", "load_dts", $$0}}' > $@	
	@(awk -v OFS=',' -v date="$$(date -u +"%Y-%m-%dT%H:%M:%SZ")" -v source=$<::$(TABNAME) '{if (NR!=1) { print NR, source, date, $$0 }}' tmp/$(basename $(<F)).tmp) >> $@
	@rm -f tmp/$(basename $(<F)).tmp
	@$(test-file)

#load-csv-into-db-overwrite
load-csv-into-db-overwrite: DBFILEPATH=etc/test/test.db
load-csv-into-db-overwrite: TABLE=SRC_$(basename $(<F))_001
load-csv-into-db-overwrite: etc/test/file_005.csv
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

#load-csv-into-db-append
load-csv-into-db-append: DBFILEPATH=etc/test/test.db
load-csv-into-db-append: TABLE=SRC_$(basename $(<F))_002
load-csv-into-db-append: etc/test/file_005.csv
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

#test-database
test-database: etc/test/test.db
	@#test-<database.db>(colon)(space)<path/to/database.db>
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"DB $< exists - $(shell $(SQLITE3) $< ".databases")\"

#test-table
test-table: TABLE=SRC_file_005_001
test-table: etc/test/test.db
	@#test-<table_name>(colon)(space)TABLE=<table_name>
	@#test-<table_name>(colon)(space)<path/to/database.db>
	@[[ $(shell $(SQLITE3) $< ".tables $(TABLE)" ".quit") == $(TABLE) ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Table $(TABLE) exists\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"Table $(TABLE) not found\"  

#record-count-table
record-count-table: TABLE=SRC_file_005_001
record-count-table: etc/test/test.db
	@#record-count-<table name>(colon)(space)TABLENAME=<table_name>
	@#record-count-<table name>(colon)(space)<path/to/database.db>
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"$(shell $(SQLITE3) $< \
	"SELECT COUNT(*) || ' records in $<::$(TABLE)' FROM [$(TABLE)]" ".quit")\"

#create-table
#create-table: DBFILEPATH=etc/test/test.db
#create-table: TABLE=FILE_005_001
#create-table: etc/test/FILE_005_001_create.sql etc/test/test.db
#	@#create-<table_name>(colon)(space)DBFILEPATH=<path/to/database_name.db>
#	@#create-<table_name>(colon)(space)TABLENAME=<table_name>
#	@#create-<table_name>(colon)(space)<path/to/<table_name>_create.sql> [<path/to/database.db>]
#	@$(SQLITE3) $(DBFILEPATH) ".read $<" ".quit"
#	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created table $(TABLE) in $(DBFILEPATH)\"

#execute-sql
execute-sql: DBFILEPATH=etc/test/test.db
execute-sql: etc/test/FILE_005_001_query_001.sql etc/test/test.db
	@#create-<table_name>(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#create-<table_name>(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>]
	@$(SQLITE3) $(DBFILEPATH) ".read $<" ".quit"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< on $(DBFILEPATH)\"

#export-csv
etc/test/FILE_005_001_query_001.csv: DBFILEPATH=etc/test/test.db
etc/test/FILE_005_001_query_001.csv: etc/test/FILE_005_001_query_001.sql .FORCE
	@#path/to/extract.csv(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#path/to/extract.csv(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>]
	@$(SQL2CSV) --db sqlite:///$(DBFILEPATH) $< > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< exported to $@\"

#export-json
etc/test/load/FILE_005_001_query_001.json: DBFILEPATH=etc/test/test.db
etc/test/load/FILE_005_001_query_001.json: etc/test/FILE_005_001_query_001.sql .FORCE
	@#path/to/extract.csv(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#path/to/extract.csv(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>] .FORCE
	@$(SQLITEUTILS) $(DBFILEPATH) "$(shell cat $<)" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< exported to $@\"

#export-json-nl
etc/test/load/FILE_005_001_query_001_nl.json: DBFILEPATH=etc/test/test.db
etc/test/load/FILE_005_001_query_001_nl.json: etc/test/FILE_005_001_query_001.sql .FORCE
	@#path/to/extract.csv(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#path/to/extract.csv(colon)(space)<path/to/<query_file>.sql> [<path/to/database.db> <dependent tables>] .FORCE
	@$(SQLITEUTILS) --nl $(DBFILEPATH) "$(shell cat $<)" > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $< exported to $@\"

#help
makefile-list:
	@echo $(MAKEFILE_LIST)

help-makefile: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

#table-metadata
table-metadata: etc/test/test.db
	@#table-metadata(colon)(space)<path/to/database.db>"
	@$(SQLITE3) $< "DROP TABLE IF EXISTS '_analyze_tables_';" ".quit"
	@$(SQLITE3) $< "DROP TABLE IF EXISTS 'META_TABLES_001';" ".quit"
	@$(SQLITEUTILS) analyze-tables $< --save
	@$(SQLITE3) $< "ALTER TABLE '_analyze_tables_' RENAME TO 'META_TABLES_001';" ".quit"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed $@ on $<	\"

#er-diagram
etc/test/er-diagram.pdf: DBFILEPATH=etc/test/test.db
etc/test/er-diagram.pdf: REL_FILE=etc/test/er_relationships.txt
etc/test/er-diagram.pdf: .FORCE etc/test/er_relationships.txt
	@#<path/to/diagram.type>(colon)(space)DBFILEPATH=<path/to/database_name.db>
	@#<path/to/diagram.type>(colon)(space)REL_FILE="<path/to/relationship_file.txt>"
	@#<path/to/diagram.type>(colon)(space)<table_name(s)>"
	@#Types can be er, pdf, png, dot
	@$(ERALCHEMY) -i sqlite:///$(DBFILEPATH) -o tmp/$(subst .,,$(notdir $(DBFILEPATH))).er
	@cat tmp/$(subst .,,$(notdir $(DBFILEPATH))).er $(REL_FILE) > tmp/$(subst .,,$(notdir $(DBFILEPATH)))_2.er || true
	@$(ERALCHEMY) -i tmp/$(subst .,,$(notdir $(DBFILEPATH)))_2.er -o $@
	@rm -f tmp/$(subst .,,$(notdir $(DBFILEPATH)))*.er
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Executed er-digram and exported to $@\"

#compact-database
compact-database: etc/test/test.db
	@#compact-database(colon)(space)<path/to/database.db>
	@$(SQLITE3) $< "PRAGMA optimize;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Optimized $<\"
	@$(SQLITE3) $< "PRAGMA auto_vacuum;" && $(SQLITE3) $< "VACUUM;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Vacuumed $<\"
	@$(SQLITE3) $< "PRAGMA integrity_check;" && echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Performed integrity check on $<\"

#backup-database
backup-database: BACKUPFILEPATH=etc/test/$(<F).bak
backup-database: etc/test/test.db
	@#backup-database(colon)(space)BACKUPFILEPATH=<path/to/database.bak>
	@#backup-database(colon)(space)<path/to/database.db>
	@$(SQLITE3) $< ".backup $(BACKUPFILEPATH)"
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Backed up $< into $(BACKUPFILEPATH)\"

#log-rotate
log-rotate: LOGFILEPATH=etc/test/logfile.log
log-rotate: mock-logfile.log
	@#log_rotate:(colon)(space)LOGFILEPATH=<path/to/logfile>
	@#log_rotate:(colon)(space)<dependencies>
	@mv $(LOGFILEPATH) $(basename $(LOGFILEPATH))_$(shell date +%Y-%m-%d).log
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Rotated $(LOGFILEPATH) into $(basename $(LOGFILEPATH))_$(shell date +%Y-%m-%d).txt\"

#directory-listing
etc/test/directory_listing.txt: .FORCE
	@#<path/to/directory_listing.txt>(colon)(space).FORCE
	@$(TREE) --prune > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created directory list at $@\"

#makefile-graph
etc/test/makefile_graph.png: .FORCE
	@#<path/to/directory_listing.txt>(colon)(space).FORCE
	@$(NODEGRAPH) --direction LR | $(GRAPHVIZDOT) -Tpng > $@
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created makefile diagram at $@\"

#ping-test
ping-test-pass: URL=https://www.google.com/
ping-test-pass: .FORCE
	@#<name-of-test>(colon)(space)URL=<URL to be tested>
	@#<name-of-test>(colon)(space)[.FORCE]	
	@$(if $(shell curl $(strip $(URL)) -fIs | head -n 1), \
	echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"$(strip $(URL)) - $(shell curl $(strip $(URL)) -fIs | head -n 1), \
	echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"$(strip $(URL)) is unavailable)\"

ping-test-fail: URL=https://www.googlefoobarbaz.com/
ping-test-fail: .FORCE
	@#<name-of-test>(colon)(space)URL=<URL to be tested>
	@#<name-of-test>(colon)(space)[.FORCE]
	@$(if $(shell curl $(strip $(URL)) -fIs | head -n 1), \
	echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"$(strip $(URL)) - $(shell curl $(strip $(URL)) -fIs | head -n 1), \
	echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"$(strip $(URL)) is unavailable)\"

#load-test-report
etc/test/load-test-report-google.txt: URL=https://www.google.com/
etc/test/load-test-report-google.txt: PARAMETERS="-n 10 -c 1"
etc/test/load-test-report-google.txt: .FORCE
	@#<path/to/output/file.txt>(colon)(space)URL=<URL to be tested>
	@#<path/to/output/file.txt>(colon)(space)PARAMETERS="-n 100 -c 10" <n=number of iterations>, c=<concurrent connections>
	@#<path/to/output/file.txt>(colon)(space).FORCE
	@ab $(PARAMETERS) -g $(basename $@).tmp $(URL) > $(basename $@)_$(shell date +%Y-%m-%d).txt
	@rm -f $(basename $@).tmp
	@echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@    \"Created report at $@\"

# load-test-metric-discrete
etc/test/load-test-metrics-google.csv: URL=https://www.google.com/
etc/test/load-test-metrics-google.csv: PARAMETERS="-n 10 -c 1"
etc/test/load-test-metrics-google.csv: .FORCE
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


#sql_template_from_csv
template-sql-SRC_TABLE: 
	@#make template-sql-SRC_TABLE CSVPATH=<path/to/file.csv> OUTPUTPATH=<path/to/output/directory>
	@#make template-sql-SRC_TABLE CSVPATH=etc/test/file_005.csv OUTPUTPATH=etc/test
	@echo $(DTS)    [INFO] - Creating script for SRC_$(notdir $(basename $(CSVPATH)))_###_create from $(CSVPATH)
	@if test -s $(CSVPATH); then echo [PASS] - $(CSVPATH) file exists; \
	else echo [FAIL] - $(CSVPATH) file does not exist; fi
	@$(SQLITE3) tmp/temp.db ".import --csv $(CSVPATH) SRC_$(notdir $(basename $(CSVPATH)))_###"
	@$(SQLITE3) tmp/temp.db ".schema SRC_$(notdir $(basename $(CSVPATH)))_###"
	@echo "--$(OUTPUTPATH)/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql" \
	> etc/sql/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@echo "-------------------------------------------------------------------------------" \
	>> $(OUTPUTPATH)/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@$(SQLITE3) tmp/temp.db ".schema SRC_$(notdir $(basename $(CSVPATH)))_###" \
	>> $(OUTPUTPATH)/SRC_$(notdir $(basename $(CSVPATH)))_###_create.sql
	@rm tmp/temp.db

test-sql-template-SRC: .FORCE
	@$(shell (make template-sql-SRC_TABLE CSVPATH=etc/test/file_005.csv OUTPUTPATH=etc/test))


#vega_report_from_api

#vega_report_from_file