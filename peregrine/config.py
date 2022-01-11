"""App instance configuration."""
import os
import dotenv
dotenv.load_dotenv(override=True)


class Config:
    LOG_PATH = os.getenv('LOG_PATH')
