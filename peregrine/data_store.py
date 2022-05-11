import json
from peregrine.config import Config


class DataStore():
    def __init__(self):
        super().__init__()

    def read_data(self):
        try:
            log_data = json.loads(Config.LOG_PATH.read_text())
        except FileNotFoundError:
            return []
        return log_data

    def write_data(self, data):
        Config.LOG_PATH.write_text(json.dumps(data))
