# https://ltp.sourceforge.net/coverage/lcov.php
.PHONY: code-coverage
code-coverage:
	@lcov --capture --directory . --output-file coverage.info
	@genhtml coverage.info --output-directory .

.PHONY: simple-server
# access html in brower
simple-server:
	@python -m http.server 8080
