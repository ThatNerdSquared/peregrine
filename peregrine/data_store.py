import json
from peregrine.config import Config
from peregrine.types import LogSchema
from pydantic.json import pydantic_encoder


class DataStore():
    def __init__(self):
        super().__init__()

    def read_data(self):
        try:
            log_data: list[LogSchema] = json.loads(Config.LOG_PATH.read_text())
        except FileNotFoundError:
            return []
        return log_data

    def write_data(self, data: list[LogSchema]):
        Config.LOG_PATH.write_text(
            json.dumps(data, default=pydantic_encoder)
        )

    def add_log_item(self, input_text, MODEL):
        """Adds a new entry to the log."""

        new_entry = LogSchema(
            input=input_text,
        )

        MODEL.entries.append(new_entry)
        self.write_data(MODEL.entries)
