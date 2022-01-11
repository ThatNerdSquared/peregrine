PYTHON := python3

lint:
	@echo "Linting..."
	@${PYTHON} -m flake8 *.py **/*.py
	@echo "Done!"

run: lint
	@${PYTHON} app.py

