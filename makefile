# ~/projects/<project_name>/makefile
# Execute the data pipeline for a project.
#
# make all                  Executes the default make task.
# make info                 Generates the informational files.
# make check                Executes all test suites.
# make installcheck         Run the project test suite.
# make install              Builds the database and application structure.
# make uninstall            Uninstalls the project.
# make run                  Executes the data pipelines.
# make help                 List of all makefile tasks.
# make documentation        Builds the documentation files for the build. (e.g. schema docs, data flow diagrams)
# make uninstalldirs        Removes the project directories. "make uninstall"
# make installcheck         Run the installation test suite.
#
##############################################################

include etc/pipeline/config.mk
include etc/pipeline/macros.mk
include etc/pipeline/unit-test.mk

define help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | sort | \
	awk 'BEGIN {FS = ":.*?## "};\
	{printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

###############################################################################
all: run ## Executes the default make task.
info: help info/variables documentation ## Generates the informational files.
check: test/inputs test/outputs ## Executes all test suites.
installcheck: test/inputs ## Run the project test suite.
install: test/inputs ## Builds the database and application structure.
uninstall: uninstalldirs ## Uninstalls the project.
run: test/inputs build/local table_metadata documentation metrics ## Executes the data pipelines.
deploy: deploy/local ## Deploys a local web server.
unit-tests: mock-uninstalldirs mock-data test-macro ## Run unit tests

.PHONY: all info check installcheck install uninstall run deploy help documentation \
	table_metadata installdirs uninstalldirs log_rotate compact_database info/variables template/src_from_csv

.FORCE:

################################################################################
# Configuration and utilities                                                  #
################################################################################
installdirs: ## Creates the project directories.
	@echo $(DTS)    [INFO] - Executing $@
	@mkdir -p svc/load/metrics/discrete
	@mkdir -p svc/load/SensorPush/OUTDOOR_01/

uninstalldirs: ## Removes the project directories. "make uninstall"
	@echo $(DTS)    [INFO] - Executing $@
	@rm -rf svc/db/* svc/doc/* svc/load/* svc/static/* opt/local/static/* opt/local/*

log_rotate: LOGFILEPATH=$(LOGFILE) ## Rotates log files.
log_rotate: 
	@$(log-rotate)

compact_database: $(DBFILE) ## Database maintenance scripts.
	@$(compact-database)



################################################################################
# Documentation                                                                #
################################################################################
help: ## List of all makefile tasks.
	@$(help)

documentation: svc/doc/directory_listing.txt svc/doc/makefile_graph.png table_metadata svc/doc/er_diagram.pdf ## Creates the documentation files for the build. (e.g. schema docs, data flow diagrams)

svc/doc/directory_listing.txt: .FORCE
	@$(directory-listing)

svc/doc/makefile_graph.png: .FORCE
	@$(makefile-graph)

table_metadata: svc/db/metrics.db
	@$(table_metadata)

#er_diagrams: 
#	@echo $(DTS)    [INFO] - Executing $<
#	@$(ERALCHEMY) -i sqlite:///etc/test/test.db -o etc/test/er_tables.er


################################################################################
# Integration Tests                                                            #
################################################################################
.PHONY: test/inputs test/outputs test/database metrics metrics/SRC_online_retail_II_001

test-inputs: svc/source/online_retail_II.xlsx

test-outputs: test/database

test-database: svc/db/online_retail.db
	$(test_database)

metrics: metrics/SRC_online_retail_II_001 metrics/META_TABLES_001

metrics/SRC_online_retail_II_001: svc/db/online_retail.db
	@$(record_count_table)

metrics/META_TABLES_001: svc/db/online_retail.db
	@$(record_count_table)

################################################################################
# Project Pipeline                                                             #
################################################################################
.PHONY: load_csv/SRC_online_retail_II_001 build/local deploy/local

svc/source/online_retail_II.xlsx: PATH="https://archive.ics.uci.edu/ml/machine-learning-databases/00502/online_retail_II.xlsx"
svc/source/online_retail_II.xlsx:
	@echo $(DTS)    [INFO] - Executing $@
	@$(CURL) -o $@ $(PATH)

svc/load/online_retail_II_-_Year_2010-2011.csv: TABNAME = "Year 2010-2011"
svc/load/online_retail_II_-_Year_2010-2011.csv: svc/source/online_retail_II.xlsx
	@$(extract_csv_from_excel)

load_csv/SRC_online_retail_II_001: DBFILE=svc/db/online_retail.db
load_csv/SRC_online_retail_II_001: svc/load/online_retail_II_-_Year_2010-2011.csv
	@$(load_csv_into_database)

svc/db/online_retail.db: load_csv/SRC_online_retail_II_001

build/local: svc/db/online_retail.db
	@echo $(DTS)     [INFO] - Executing $@
	@mkdir -p opt/$(notdir $@)/static
	@cp -f etc/app/metadata.yaml opt/local/metadata.yaml
	@cp -f etc/server/requirements.txt opt/local/requirements.txt
	@cp -f etc/server/settings.txt opt/local/settings.txt
	@cp -f $< opt/local/$(<F)

deploy/local: build/local
	@echo $(DTS)     [INFO] - Starting server on http://$(strip $(LOCAL_ADDRESS)):$(LOCAL_PORT)
	@$(DATASETTE) serve opt/local/ --host $(LOCAL_ADDRESS) --port $(LOCAL_PORT) -o


svc/load/SensorPush/OUTDOOR_02.csv: HEADER="source_line_number,provider_code,load_dts,value_dts,temperature_fahrenheit,relative_humidity_percent"
svc/load/SensorPush/OUTDOOR_02.csv: SOURCE=svc/load/SensorPush/OUTDOOR_01/SensorPushData.zip
svc/load/SensorPush/OUTDOOR_02.csv: unzip/SensorPush/OUTDOOR_01/SensorPushData
	@if test -s $@; \
	then echo $(HEADER) > $@ \
	&& (awk -v OFS=',' -v date="$$(date -u +"%Y-%m-%dT%H:%M:%SZ")" '{if (NR!=1) { print NR, FILENAME, date, $$0 }}' $(wildcard svc/load/SensorPush/OUTDOOR_01/*.csv)) >> $@; \
	else echo $(DTS)     [WARNING] - $(SOURCE) file does not exist; fi
	#rm -f $(wildcard svc/load/SensorPush/OUTDOOR_01/Outdoor_01-starts-*.csv)
	#mkdir -p tmp/$(basename $(@F)) && mv -f $(SOURCE) tmp/$(basename $(@F))
	#$(test_file)
	#wc -l $@ || true
	

svc/load/SensorPush/OUTDOOR_03.csv: .FORCE
	@#path/to/<source_reference_name_directory>/load.csv(colon)(space)
	@echo $(DTS)     [INFO] - Loading csv files from $(realpath $(dir $@)) and loading into $@
	@$(if $(abspath $(LIST_CSV)), cat $(abspath $(LIST_CSV)) >> $(addsuffix .tmp, $(basename $@)) \
	&& echo $(DTS)     [INFO] - Concatenating csv files [$(realpath $(LIST_CSV))] \
	&& wc -l $(addsuffix .tmp, $(basename $@)), \
	echo $(DTS)     [INFO] - no files to process in $(dir $@))
	@sort -u $(addsuffix .tmp, $(basename $@)) -o $@ || true
	@rm -f $(addsuffix .tmp, $(basename $@)) || true
	@find $(realpath $(dir $@)) -type f -not -name 'load.csv' -delete
	@wc -l $@ || true


svc/load/SensorPush/OUTDOOR_01.csv2: $(wildcard svc/load/SensorPush/OUTDOOR_01*.zip)
	@#<path/to/csv_file.csv>(colon)(space)<path/to/source/csv_file.csv>
	@echo $(DTS)     [INFO] - Extracting data from $(SOURCE) into $@
	@$(CSVSTACK) -n load_dts -g $(DTS) $(SOURCE) > tmp/$(@F)_1.tmp
	@$(CSVSTACK) -n provider_code -g $@ tmp/$(@F)_1.tmp > tmp/$(@F)_2.tmp
	@mv tmp/$(@F)_2.tmp $@
	@rm tmp/$(@F)_1.tmp
	@$(test_file)






#-----------------------------------#

test/metrics: \
svc/load/SensorPush/OUTDOOR_01/SensorPushData.zip \
svc/load/metrics/OUTDOOR_01/load.csv \
tmp/source/OUTDOOR_01/SensorPushData.zip

svc/load/SensorPush/OUTDOOR_01/SensorPushData.zip:
	@$(test_file_warning)

tmp/source/OUTDOOR_01/SensorPushData.zip:
	@$(test_file)	


unzip_SensorPush/OUTDOOR_01: svc/load/SensorPush/OUTDOOR_01/SensorPushData.zip
	@if test -s $<; \
	then unzip -q -o $< -d $(<D) \
	&& echo $(DTS)     [INFO] - extracting $< \
	&& mkdir -p tmp/source/$(basename $(@F)) && mv -f $< tmp/source/$(DTS)_$(basename $(@F)); \
	else echo $(DTS)     [WARNING] - $< file does not exist; fi

.PHONY: svc/load/metrics/discrete/outdoor_01.temp_f
svc/load/metrics/discrete/outdoor_01.temp_f: HEADER="provider_code,load_dts,resource_code,value_dts,metric_code,value"
svc/load/metrics/discrete/outdoor_01.temp_f: SOURCE_WILDCARD=svc/load/SensorPush/OUTDOOR_01/*.csv
svc/load/metrics/discrete/outdoor_01.temp_f: METRIC_DTS_POSITION=1
svc/load/metrics/discrete/outdoor_01.temp_f: METRIC_CODE_POSITION=2
svc/load/metrics/discrete/outdoor_01.temp_f: unzip_SensorPush/OUTDOOR_01 installdirs
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) HEADER="provider_code,load_dts,resource_code,value_dts,metric_code,value"
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) SOURCE_WILDCARD=svc/load/SensorPush/OUTDOOR_01/*.csv
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) METRIC_DTS_POSITION=<column position in source file>
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) METRIC_CODE_POSITION=<column position in source file>
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) [dependinces]
	@if test -s "$(wildcard $(SOURCE_WILDCARD))"; \
	then echo $(DTS)     [INFO] - Extracting metrics from $(wildcard $(SOURCE_WILDCARD)) into $@ \
	&& echo $(HEADER) > $(basename $@)_$(DTS).csv \
	&& (awk -v OFS=',' -v date="$$(date -u +"%Y-%m-%dT%H:%M:%SZ")" '{if (NR!=1) {split($$0,a,","); print FILENAME, date,"$(basename $(@F))",a[$(METRIC_DTS_POSITION)],"$(subst .,,$(suffix $@))",a[$(METRIC_CODE_POSITION)] }}' $(wildcard $(SOURCE_WILDCARD))) >> $(basename $@)_$(DTS).csv \
	&& wc -l $(basename $@)_$(DTS).csv || true; \
	else echo $(DTS)     [WARNING] - $(wildcard $(SOURCE_WILDCARD)) file does not exist; fi

.PHONY: svc/load/metrics/discrete/outdoor_01.relative_humidity_percent
svc/load/metrics/discrete/outdoor_01.relative_humidity_percent: HEADER="provider_code,load_dts,resource_code,value_dts,metric_code,value"
svc/load/metrics/discrete/outdoor_01.relative_humidity_percent: SOURCE_WILDCARD=svc/load/SensorPush/OUTDOOR_01/*.csv
svc/load/metrics/discrete/outdoor_01.relative_humidity_percent: METRIC_DTS_POSITION=1
svc/load/metrics/discrete/outdoor_01.relative_humidity_percent: METRIC_CODE_POSITION=3
svc/load/metrics/discrete/outdoor_01.relative_humidity_percent: unzip_SensorPush/OUTDOOR_01 installdirs
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) HEADER="provider_code,load_dts,resource_code,value_dts,metric_code,value"
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) SOURCE_WILDCARD=svc/load/SensorPush/OUTDOOR_01/*.csv
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) METRIC_DTS_POSITION=<column position in source file>
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) METRIC_CODE_POSITION=<column position in source file>
	@#path/to/metrics/discrete/<resource_code>.<metric_code>(colon)(space) [dependinces]
	@if test -s "$(wildcard $(SOURCE_WILDCARD))"; \
	then echo $(DTS)     [INFO] - Extracting metrics from $(wildcard $(SOURCE_WILDCARD)) into $@ \
	&& echo $(HEADER) > $(basename $@)_$(DTS).csv \
	&& (awk -v OFS=',' -v date="$$(date -u +"%Y-%m-%dT%H:%M:%SZ")" '{if (NR!=1) {split($$0,a,","); print FILENAME, date,"$(basename $(@F))",a[$(METRIC_DTS_POSITION)],"$(subst .,,$(suffix $@))",a[$(METRIC_CODE_POSITION)] }}' $(wildcard $(SOURCE_WILDCARD))) >> $(basename $@)_$(DTS).csv \
	&& wc -l $(basename $@)_$(DTS).csv || true; \
	else echo $(DTS)     [WARNING] - $(wildcard $(SOURCE_WILDCARD)) file does not exist; fi

svc/load/metrics/discrete/load.csv: .FORCE
	@#path/to/<source_directory>/load.csv(colon)(space) .FORCE
	@echo $(DTS)     [INFO] - Loading csv files from $(realpath $(dir $@)) and loading into $@
	@$(if $(abspath $(LIST_CSV)), cat $(abspath $(wildcard $(@D)/*.csv)) >> $(addsuffix .tmp, $(basename $@)) \
	&& echo $(DTS)     [INFO] - Concatenating csv files [$(realpath $(LIST_CSV))] \
	&& wc -l $(addsuffix .tmp, $(basename $@)), \
	echo $(DTS)     [INFO] - no files to process in $(dir $@))
	@sort -u $(addsuffix .tmp, $(basename $@)) -o $@ || true
	@rm -f $(addsuffix .tmp, $(basename $@)) || true
	@find $(realpath $(dir $@)) -type f -not -name $(@F) -delete
	wc -l $@ || true

.PHONY: clean_svc/load/SensorPush/OUTDOOR_01
clean_svc/load/SensorPush/OUTDOOR_01: SOURCE_WILDCARD=svc/load/SensorPush/OUTDOOR_01/*.csv
clean_svc/load/SensorPush/OUTDOOR_01: \
svc/load/metrics/discrete/outdoor_01.relative_humidity_percent \
svc/load/metrics/discrete/outdoor_01.temp_f \
svc/load/metrics/discrete/load.csv
	@rm -f $(wildcard $(SOURCE_WILDCARD)) || true	

etc/test/discrete_metrics_header.csv: .FORCE
	echo "provider_code,load_dts,resource_code,value_dts,metric_code,value" > $@

		