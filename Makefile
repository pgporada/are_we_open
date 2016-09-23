.ONESHELL:

help:

install-requirements:
	@pip install -r requirements.txt

zip:
	@which zip > /dev/null 2>&1; RETVAL=$$?; if [ $$RETVAL -eq 0 ]; then echo "We have zip"; else "You need the {un,}zip package for your system."; fi
	@rm -f *.zip
	@zip -r ourhours.zip *

package-it: install-requirements zip
	@echo "Packaged and ready to deploy"

test:
	@echo "I should write tests"
