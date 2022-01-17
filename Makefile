PYTHON := python3

.PHONY = lint test run build_macos build_windows remove-build-files

lint:
	@echo "Linting..."
	@${PYTHON} -m flake8 peregrine
	@echo "Done!"

test:
	@echo "Testing..."
	@${PYTHON} -m pytest tests
	@echo "Done!"

run: test lint
	@${PYTHON} app.py

build-macos: test lint
	@pyinstaller --name="Peregrine" \
		--add-data "macos-style.qss:." \
		--add-data "fonts/*.ttf;fonts/" \
		--icon assets/Peregrine.icns \
		--windowed --onefile app.py
		@#--add-data ".env:." \
		@# --osx-bundle-identifier io.github.thatnerdsquared.peregrine

build-windows: test lint
	@${PYTHON} -m PyInstaller --name="Peregrine" \
		--add-data "windows-style.qss;." \
		--add-data "fonts/*.ttf;fonts/" \
		--add-data "assets/peregrine-icon.png;." \
		--icon assets/peregrine-icon.ico \
		--windowed --onefile app.py

remove-build-files:
	@rm -rf Peregrine.spec build dist

iconset:
	@echo "Generating macOS iconset..."
	@mv assets/peregrine-icon.png .
	@mkdir Peregrine.iconset
	@sips -z 16 16     peregrine-icon.png --out Peregrine.iconset/icon_16x16.png
	@sips -z 32 32     peregrine-icon.png --out Peregrine.iconset/icon_16x16@2x.png
	@sips -z 32 32     peregrine-icon.png --out Peregrine.iconset/icon_32x32.png
	@sips -z 64 64     peregrine-icon.png --out Peregrine.iconset/icon_32x32@2x.png
	@sips -z 128 128   peregrine-icon.png --out Peregrine.iconset/icon_128x128.png
	@sips -z 256 256   peregrine-icon.png --out Peregrine.iconset/icon_128x128@2x.png
	@sips -z 256 256   peregrine-icon.png --out Peregrine.iconset/icon_256x256.png
	@sips -z 512 512   peregrine-icon.png --out Peregrine.iconset/icon_256x256@2x.png
	@sips -z 512 512   peregrine-icon.png --out Peregrine.iconset/icon_512x512.png
	@cp peregrine-icon.png Peregrine.iconset/icon_512x512@2x.png
	@iconutil -c icns Peregrine.iconset
	@rm -R Peregrine.iconset
	@mv peregrine-icon.png Peregrine.icns assets/
	@echo "Iconset generation complete!"
