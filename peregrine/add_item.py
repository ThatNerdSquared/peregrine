from datetime import datetime
from peregrine.data_store import DataStore


def add_log_item(input_text, MODEL):
    """Adds a new entry to the log."""

    now = datetime.now()
    new_entry = {
        "date": now.isoformat(),
        "input": input_text,
        "encrypted": False,
        "tags": []
    }
    MODEL.entries.append(new_entry)
    DataStore().write_data(MODEL.entries)
