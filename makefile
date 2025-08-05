.PHONY: all
all: ansible-lint yamllint cleanup

.PHONY: ansible-lint
ansible-lint:
	@echo "Running ansible-lint..."
	ansible-lint .

.PHONY: yamllint
yamllint:
	@echo "Running yamllint..."
	yamllint .

.PHONY: cleanup
cleanup:
	@echo "Cleaning up..."
	rm -rf .ansible