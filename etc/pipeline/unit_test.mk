################################################################################
# Unit Tests - etc/pipeline/unit_tests.mk                                      #
################################################################################
unit_tests: mock_data test_macro

.PHONY: mock/file_001.csv mock/file_002.csv etc1/ \
etc/pipe/ etc/pipeline/unit_test.mk etc/pipeline/unit_test.mk2

#### Data Mocks ####
mock_data: mock/file_001.csv mock/file_002.csv mock/file_003.csv mock/file_003a.csv mock/file_004.csv

mock/file_001.csv: PATH=etc/test/file_001.csv
mock/file_001.csv: .FORCE
	@echo "text,date,value" > $(PATH) 
	@echo "One,2021-11-08T21:00:00Z,1.00" >> $(PATH) 

mock/file_002.csv: PATH=etc/test/file_002.csv
mock/file_002.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "Two,2021-11-08T22:00:00Z,2.00" >> $(PATH) 

mock/file_003.csv: PATH=etc/test/file_003.csv
mock/file_003.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "Three,2021-11-08T23:00:00Z,3.00" >> $(PATH) 

mock/file_003a.csv: PATH=etc/test/file_003a.csv
mock/file_003a.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "Three,2021-11-08T23:00:00Z,3.00" >> $(PATH) 	

mock/file_004.csv: PATH=etc/test/file_004.csv
mock/file_004.csv: .FORCE
	@echo "text,date,value" > $(PATH)  
	@echo "One,2021-11-08T21:00:00Z,1.00" >> $(PATH) 
	@echo "Two,2021-11-08T22:00:00Z,2.00" >> $(PATH) 
	@echo "Three,2021-11-08T23:00:00Z,3.00" >> $(PATH) 


#### Macro tests ####
test_macro: \
test_dir_pass test_dir_fail test_dir test_dir_macro \
etc/test/file_001.csv etc/test/file_001b.csv etc/test/file_001c.csv \
etc/test/file_002.csv etc/test/file_003.csv test_dependent_file file_compare_pass \
file_compare_fail file_compare_macro record_count_csv update_file_modified_date_macro

#etc/pipeline/unit_test.mk etc/pipeline/unit_test.mk2 test_dependent_file \
test_dependent_file_fail file_compare file_compare_fail record_count_csv

.PHONY: etc2/

test_dir_pass: etc/
	@[[ -d $< ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"testing for $< found $?\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" 

test_dir_fail: etc1/
	@[[ -d $< ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< found $?\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@    \"testing for $</ did not find $?\" 

test_dir: etc/
	@[[ -d $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"testing for $< did not find $?\" 

test_dir_macro: etc/
	$(test_dir)

etc/test/file_001.csv: NAME = test_file_pass
etc/test/file_001.csv: mock/file_001.csv
	@[[ -f $@ ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $(NAME)     \"testing for $@ found $@\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 

etc/test/file_001b.csv: NAME = test_file_fail
etc/test/file_001b.csv: 
	@[[ -f $@ ]] \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $@ found $@\" \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $(NAME)     \"testing for $@ did not find $@\" 

etc/test/file_001c.csv: NAME = test_file_warning
etc/test/file_001c.csv: 
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $(NAME)     \"testing for $@ did not find $@\" 

etc/test/file_002.csv: NAME = test_file
etc/test/file_002.csv: mock/file_002.csv
	@[[ -f $@ ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $(NAME)     \"testing for $< did not find $@\" 

etc/test/file_003.csv: NAME = test_file_macro
etc/test/file_003.csv: mock/file_003.csv
	$(test_file)

test_dependent_file: etc/test/file_001.csv
	@[[ -f $< ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@     \"testing for $< did not find $<\" 

file_compare_pass: etc/test/file_003.csv etc/test/file_003a.csv
	@cmp -s $(word 1,$^) $(word 2,$^) \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@     \"$(word 1,$^) is not the same as $(word 2,$^)\" 

file_compare_fail: etc/test/file_002.csv etc/test/file_003.csv
	@cmp -s $(word 1,$^) $(word 2,$^) \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [PASS]    $@     \"$(word 1,$^) is not the same as $(word 2,$^)\" 

file_compare_macro: etc/test/file_003.csv etc/test/file_003a.csv
	@$(file_compare)

record_count_csv: PATH=etc/test/file_004.csv
record_count_csv: EXPECTED=4
record_count_csv: mock/file_004.csv
	@[[ $(shell wc -l < $(PATH)) == $(EXPECTED) ]] \
	&& true \
	|| echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [FAIL]    $@    \"record count $(PATH) is $(shell wc -l < $(PATH)) not $(EXPECTED)\"  

update_file_modified_date: etc/test/file_004.csv
	@date -r $< +"%Y-%m-%dT%H:%M:%SZ" 
	@touch $<
	@date -r $< +"%Y-%m-%dT%H:%M:%SZ" 

update_file_modified_date_macro: etc/test/file_004.csv
	@touch $< \
	&& echo $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")    [INFO]    $@     \"Updating file modification date for $< to $(shell date -r $< +"%Y-%m-%dT%H:%M:%SZ")\" 

#split_csv








#extract_csv_from_excel

#load_csv_into_database

#test_database

#test_table

#record_count_table

#execute_sql

#execute_sql_export_csv

#create_table



#vega_report_from_api

#vega_report_from_file


#sql_template_from_csv



#help

#er_diagram

#table_metadata

#log_rotate

#compact_database