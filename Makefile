PORT=9000

serve:
	@hugo server -p $(PORT) --navigateToChanged --openBrowser

build:
	@hugo build

spell:
	@typos --exclude themes

links:
	@lychee . --exclude-path themes

clean:
	@echo
	@echo "--------------- DELETING BUILD FOLDERS --------------"
	rm -rf public
	rm -rf resources
	@echo "----------------- CLEAN UP COMPLETE -----------------"
	@echo

help:
	@echo
	@echo "======================= USAGE ======================="
	@echo " make serve   <-- Build and serve locally"
	@echo " make build   <-- Build the static website files"
	@echo " make clean   <-- Delete all the build files"
	@echo " make spell   <-- Check for spelling errors"
	@echo " make links   <-- Check for broken web links"
	@echo " make help    <-- Print this usage message"
	@echo

.PHONY: serve build spell links clean help
