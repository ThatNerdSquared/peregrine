PYTHON := python3

lint:
	@echo "Linting..."

	@# There is a problem with Pylint doing its own discovery. Issue here:
	@# https://github.com/PyCQA/pylint/issues/352
	@${PYTHON} -m pylint \
		--disable=C0111 \
		*.py \

