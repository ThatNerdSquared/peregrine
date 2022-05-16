"""App instance configuration."""
import dotenv
import os
import platform
from pathlib import Path
from PySide6.QtGui import QKeySequence

dotenv.load_dotenv(override=True)


class Config:
    PEREGRINE_DEV_MODE = str(os.getenv('PEREGRINE_DEV_MODE')).lower()
    APP_VERSION = 1.0
    HOME_FOLDER = Path(str(
        os.getenv('USERPROFILE' if platform.system() == 'Windows' else 'HOME')
    ))
    # LOG_PATH = HOME_FOLDER / 'peregrinelog.json'
    LOG_PATH = Path(str(
        'dev_log.json' if PEREGRINE_DEV_MODE == 'true'
        else HOME_FOLDER / 'peregrinelog.json'
    ))


class Keybinds:
    NEW_ENTRY = QKeySequence('Ctrl+N')
    FIND = QKeySequence('Ctrl+F')
    FOCUS_LIST = QKeySequence('Ctrl+\\')
    REFRESH = QKeySequence('Ctrl+R')
    PREVIOUS_ITEM = QKeySequence('Shift+Return')
    ADD_ENTRY = QKeySequence('Ctrl+Return')
