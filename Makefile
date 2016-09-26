SHELL = bash
.ONESHELL:
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-virtualenv: ## Sets up the local repository for a python virtualenv
	@echo "+) Building virtualenv in local folder"
	@virtualenv .
	@echo "+) Finished building virtualenv"

install-requirements: ## Install python requirements in a virtualenv
	@echo "+) Activating virtualenv"
	@source bin/activate
	@pip install -r requirements.txt
	@echo "+) Deactivating virtualenv"
	@deactivate

zip: ## Zip up files needed to run on AWS Lambda
	@which zip > /dev/null 2>&1; RETVAL=$$?; if [ $$RETVAL -eq 0 ]; then echo "+) Zip binary already installed"; else "-) You need the {un,}zip package for your system."; fi
	@echo "+) Removing old zip"
	@rm -f *.zip
	@WORKINGDIR=$$(pwd)
	@echo "+) Entering lib/python2.7/site-packages/"
	@pushd lib/python2.7/site-packages/ > /dev/null
	@echo "+) Finding files to package"
	@find \( ! -name "*.so" \) | sed 's|^./||' | xargs zip -r -9 -q $$WORKINGDIR/lambda.zip
	@echo "+) Leaving lib/python2.7/site-packages/"
	@popd > /dev/null
	@echo "+) Adding handler script to the package"
	@zip -r -9 -q lambda.zip ourhours.py

package-it: build-virtualenv install-requirements zip ## Do everything for me
	@echo "+) Packaged and ready to deploy to AWS Lambda"

test: ## I should really learn to write these
	@echo "-) I should write tests"
