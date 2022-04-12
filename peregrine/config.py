"""App instance configuration."""
import os
import platform
from pathlib import Path


class Config:
    HOME_FOLDER = Path(str(
        os.getenv('USERPROFILE' if platform.system() == 'Windows' else 'HOME')
    ))
    LOG_PATH = HOME_FOLDER / 'peregrinelog.json'
