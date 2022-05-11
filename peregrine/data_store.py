import json
from datetime import datetime
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

    def add_log_item(self, input_text, MODEL):
        """Adds a new entry to the log."""

        now = datetime.now()
        new_entry = {
            "date": now.isoformat(),
            "input": input_text,
            "encrypted": False,
            "tags": []
        }
        MODEL.entries.append(new_entry)
        self.write_data(MODEL.entries)
