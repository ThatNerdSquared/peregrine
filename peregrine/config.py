"""App instance configuration."""
import os
import dotenv
from peregrine import utils

dotenv.load_dotenv(dotenv_path=utils.get_data_file_path('.env'), override=True)


class Config:
    LOG_PATH = os.getenv('LOG_PATH')
