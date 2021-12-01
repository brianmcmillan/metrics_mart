################################################################################
# Configuration helper variables - etc/pipeline/config.mk                      #
################################################################################

# Deployment variables
LOCAL_ADDRESS := $(shell ipconfig getifaddr en0) #192.168.1.251
LOCAL_PORT := 8001

# Program locations (which <utility>)
SHELL := $(shell which bash)
SQLITE3 := $(shell which sqlite3)
SPLIT := $(shell which gsplit)
TREE := $(shell which tree)
CURL := $(shell which curl)
GRAPHVIZDOT := $(shell which dot)
GCLOUD := $(shell which gcloud)
#PYENVDIR := /Users/brianmcmillan/.pyenv/shims)
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

