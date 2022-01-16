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

build: test lint
	pyinstaller --name="Peregrine" --add-data "style.qss, .env:." --windowed --onefile  app.py

remove-build-files:
	rm -rf app.spec build dist
