PYTHON := python3

lint:
	@echo "Linting..."

	@# pylint can't find files properly
	@# https://github.com/PyCQA/pylint/issues/352
	@${PYTHON} -m pylint \
		*.py \

run: 
	@${PYTHON} app.py

