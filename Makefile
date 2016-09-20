.ONESHELL:

zip:
	@which zip > /dev/null 2>&1; RETVAL=$$?; if [ $$RETVAL -eq 0 ]; then echo "We have zip"; else "You need the {un,}zip package for your system."; fi
