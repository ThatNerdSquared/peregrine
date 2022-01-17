# Peregrine

Peregrine is a rapid, append-only logging and note-taking app, inspired by thesephist's [Inc](https://github.com/thesephist/inc). 

<img src="assets/readme-image.png" style="max-width:800px">

## Installation
Peregrine now offers prebuilt app packages! You can get the lastest one on our [releases page](). I currently have releases for Windows and M1 macs. On macOS, copy the `.app` bundle into `/Applications/`. On Windows, copy the `.exe` into `C:\Program Files`. If you're on an Intel mac or Linux, follow the instructions below to build from source. 

You can find logged entries as a file called `~/peregrinelog.json` or `C:\Users\yourusername\peregrinelog.json`, depending on your OS. Breaking changes with the current log file format are unlikely but still possible at this time.

### Build from Source
```bash
git clone git@github.com:ThatNerdSquared/peregrine.git
cd peregrine
pip3 install -r requirements.txt
make run # run Peregrine from the current python install and shell
# MAKE BUILD IS CURRENTLY NOT SUPPORTED FOR LINUX.
make build-macos # build a .app file for macOS on the current architecture.
make build-windows # build a .exe file for Windows on the current architecture.
```

## Features
I'm iterating on Peregrine rapidly, so if a feature you'd like isn't checked off yet, come back in a week and it might be done.
- [x] Append-only note-taking
- [x] Rapid text input that automatically records the date and time (down to the seconds) of each entry
- [x] Fast and light GUI
- [x] Packaged apps for Windows/macOS using PyInstaller
- [ ] Tag support (can tag entries and create views with filters for certain tags)
- [ ] Set entries to be password-protected by tagging them as #secret
- [ ] Markdown and syntax highlighting support
- [ ] Light/dark themes
- [ ] Automatically export logs to .md/.json/.docx/.pdf files
- [ ] Automatically create and update webpage with entries tagged #public

## Other Details
- What's the idea behind Peregrine?
    - I'd suggest checking out Linus' [original article on incremental note-taking](https://thesephist.com/posts/inc/); his project based on that idea, Inc, is what inspired me to build Peregrine. Mainly I wanted something like Inc, but with GUI support and better tagging views, as well as being built in Python which makes the project easier for others to iterate on.
- What did you build this with?
    - Python, PySide6, and Qt6! I'm most comfortable with Python and also wanted to avoid Electron for an app that needed to be this fast.
- ... peregrine?
    - Yup, [peregrine falcons](https://en.wikipedia.org/wiki/Peregrine_falcon), which are both cool and fast (hopefully like this app)!
- If you enjoy using Peregrine and/or want to support further develop, feel free to donate below!

<a href="https://www.buymeacoffee.com/nathanyeung" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
