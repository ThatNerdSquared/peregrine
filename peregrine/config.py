import os

import dotenv
dotenv.load_dotenv(override=True)

class Config:
    """App instance configuration."""
    LOG_PATH = os.getenv('LOG_PATH')
