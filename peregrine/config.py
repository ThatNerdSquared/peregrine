"""App instance configuration."""
from PySide6.QtGui import QFont
import dotenv
import os
import platform
from pathlib import Path

dotenv.load_dotenv(override=True)


class Config:
    PEREGRINE_DEV_MODE = str(os.getenv('PEREGRINE_DEV_MODE')).lower()
    APP_VERSION = "1.0.0"
    HOME_FOLDER = Path(str(
        os.getenv('USERPROFILE' if platform.system() == 'Windows' else 'HOME')
    ))
    # LOG_PATH = HOME_FOLDER / 'peregrinelog.json'
    LOG_PATH = Path(str(
        'dev_log.json' if PEREGRINE_DEV_MODE == 'true'
        else HOME_FOLDER / 'peregrinelog.json'
    ))
    DATE_FONT = QFont('Krete', 14)
    ENTRY_FONT = QFont('Krete', 11)


class Keybinds:
    NEW_ENTRY = 'Ctrl+N'
    FIND = 'Ctrl+F'
    FOCUS_LIST = 'Ctrl+\\'
    REFRESH = 'Ctrl+R'
    PREVIOUS_ITEM = 'Alt+Return'
    ADD_ENTRY = 'Ctrl+Return'
