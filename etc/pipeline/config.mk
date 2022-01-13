################################################################################
# Configuration helper variables - etc/pipeline/config.mk                      #
################################################################################

# Deployment variables
LOCAL_ADDRESS := $(shell ipconfig getifaddr en0) #192.168.1.251
LOCAL_PORT := 8001

# Program locations (which <utility>)
PYENVDIR := /Users/brianmcmillan/.pyenv/shims
SHELL := $(shell which bash)
GAWK := $(shell which gawk)
SQLITE3 := $(shell which sqlite3)
SPLIT := $(shell which gsplit)
TREE := $(shell which tree)
CURL := $(shell which curl)
BASE64 := $(shell which base64)
GRAPHVIZDOT := $(shell which dot)
GCLOUD := $(shell which gcloud)
PYTHON3 := $(shell which python3)
PIP := $(shell which pip)
IN2CSV := $(shell which in2csv)
SQL2CSV := $(shell which sql2csv)
CSVSTACK := $(shell which csvstack)
CSVSQL := $(shell which csvsql)
SQLITEUTILS := $(shell which sqlite-utils)
NODEGRAPH := $(shell which makefile2dot)
DATASETTE := $(shell which datasette)
ERALCHEMY := $(shell which eralchemy)

# Utility variables
DTS = $(shell date +%Y-%m-%dT%H:%M:%S-%Z)
LIST_CSV = $(shell find $(dir $@) -type f -name '*.csv' -not -name 'load.csv')

info-variables: ## List the variables in the makefile.
	@echo $(DTS)    [INFO] - Executing $@
	@echo LOCAL_ADDRESS = $(LOCAL_ADDRESS)
	@echo LOCAL_PORT = $(LOCAL_PORT)
	@echo "-- Program paths ----------------------------------------------------"
	@echo SHELL = $(SHELL)
	@echo GAWK = $(GAWK)	
	@echo SQLITE3 = $(SQLITE3)
	@echo GRAPHVIZDOT = $(GRAPHVIZDOT)
	@echo SPLIT = $(SPLIT)
	@echo TREE = $(TREE)
	@echo GCLOUD = $(GCLOUD)
	@echo PYENVDIR = $(PYENVDIR)
	@echo PYTHON3 = $(PYTHON3)
	@echo PIP = $(PIP)
	@echo IN2CSV = $(IN2CSV)
	@echo CSVSTACK = $(CSVSTACK)
	@echo CSVSQL = $(CSVSQL)
	@echo SQLITEUTILS = $(SQLITEUTILS)
	@echo DATASETTE = $(DATASETTE)
	@echo NODEGRAPH = $(NODEGRAPH)
	@echo ERALCHEMY = $(ERALCHEMY)
	@echo ""

# Project directory paths
ROOTDIR := $(shell pwd)
PROJECTDIR := $(ROOTDIR)
PROJECTNAME := $(notdir $(ROOTDIR))
# /etc
SYSCONFIGDIR := $(PROJECTDIR)/etc
APPCONFIGDIR := $(PROJECTDIR)/etc/app
SCHEDULECONFIGDIR := $(PROJECTDIR)/etc/cron
SERVERCONFIGDIR := $(PROJECTDIR)/etc/server
SQLDIR := $(PROJECTDIR)/etc/sql
TESTSDIR := $(PROJECTDIR)/etc/test
# /opt
OPTIONALPKGDIR := $(PROJECTDIR)/opt
LOCALDEPLOYMENTDIR := $(PROJECTDIR)/opt/local
PYTHONSCRIPTS := $(PROJECTDIR)/opt/python
LOCALSQLITE3 := $(PROJECTDIR)/opt/sqlite3
# /src
SOURCEDIR := $(PROJECTDIR)/src
SQLITESRCDIR := $(PROJECTDIR)/src/sqlite3
# /srv
SERVICEDIR := $(PROJECTDIR)/svc
CUSTOMERFILEDIR := $(PROJECTDIR)/svc/source
LOADFILEDIR := $(PROJECTDIR)/svc/load
STATICFILEDIR := $(PROJECTDIR)/svc/static
DOCUMENTATIONDIR := $(PROJECTDIR)/svc/doc
DATABASEDIR := $(PROJECTDIR)/svc/db
# /tmp /var
TEMPSTATEDIR := $(PROJECTDIR)/tmp
LOCALSTATEDIR := $(PROJECTDIR)/var
PROJECTLOGDIR := $(LOCALSTATEDIR)/log
# Project files
DBNAME := $(PROJECTNAME).db
DBFILE := $(DATABASEDIR)/$(PROJECTNAME).db
LOGFILE := $(PROJECTLOGDIR)/$(PROJECTNAME).log


info-directories: ## List the directories	
	@echo "-- Directory paths ----------------------------------------------------"
	@echo ROOTDIR = $(ROOTDIR)
	@echo PROJECTDIR = $(PROJECTDIR)
	@echo PROJECTNAME = $(PROJECTNAME)
	@echo "----------"
	@echo PROJECTLOGDIR = $(PROJECTLOGDIR)
	@echo DBNAME = $(DBNAME)
	@echo LOGFILE = $(LOGFILE)
	@echo "----------"	
	@echo SYSCONFIGDIR = $(SYSCONFIGDIR)
	@echo APPCONFIGDIR = $(APPCONFIGDIR)
	@echo SCHEDULECONFIGDIR = $(SCHEDULECONFIGDIR)
	@echo SERVERCONFIGDIR = $(SERVERCONFIGDIR)
	@echo SQLDIR = $(SQLDIR)
	@echo TESTSDIR = $(TESTSDIR)
	@echo OPTIONALPKGDIR = $(OPTIONALPKGDIR)
	@echo LOCALDEPLOYMENTDIR = $(LOCALDEPLOYMENTDIR)
	@echo PYTHONSCRIPTS = $(PYTHONSCRIPTS)
	@echo LOCALSQLITE3 = $(LOCALSQLITE3)
	@echo SOURCEDIR = $(SOURCEDIR)
	@echo SERVICEDIR = $(SERVICEDIR)
	@echo CUSTOMERFILEDIR = $(CUSTOMERFILEDIR)
	@echo LOADFILEDIR = $(LOADFILEDIR)
	@echo STATICFILEDIR = $(STATICFILEDIR)
	@echo DOCUMENTATIONDIR = $(DOCUMENTATIONDIR)
	@echo DATABASEDIR = $(DATABASEDIR)
	@echo TEMPSTATEDIR = $(TEMPSTATEDIR)
	@echo LOCALSTATEDIR = $(LOCALSTATEDIR)
	@echo ""

	