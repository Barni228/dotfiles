.PHONY: pre_test test

pre_test:
	@echo "Running pre-test command"
	rm -rf $(CURDIR)/_t
	cp -r $(CURDIR)/test_files $(CURDIR)/_t

test: pre_test
	cargo test
	rm -rf $(CURDIR)/_t