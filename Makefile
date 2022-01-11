PYTHON := python3

lint:
	@echo "Linting..."
	@${PYTHON} -m flake8 *.py **/*.py
	@echo "Done!"

test:
	@echo "Testing..."
	@${PYTHON} -m pytest tests
	@echo "Done!"

run: test lint
	@${PYTHON} app.py

