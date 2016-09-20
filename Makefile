.ONESHELL:

install-requirements:
	@pip install -r requirements -t bundle

zip:
	@which zip > /dev/null 2>&1; RETVAL=$$?; if [ $$RETVAL -eq 0 ]; then echo "We have zip"; else "You need the {un,}zip package for your system."; fi
	@rm -f are_we_open.zip
	@zip -r are_we_open.zip *

package-it: install-requirements zip
	@echo "Packaged and ready to deploy"

test:
	@echo "I should write tests"
