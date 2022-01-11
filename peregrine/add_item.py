import os
import json
from datetime import datetime
from peregrine.config import Config

def add_log_item(input_text):
    """Adds a new entry to the log."""

    now = datetime.now()
    new_entry = {
        "date": now.isoformat(),
        "input": input_text
    }
    path = Config.LOG_PATH + 'peregrinelog.json'
    if not os.path.exists(path):
        with open(path, 'w+', encoding='UTF-8') as log_file:
            entries = [ new_entry ]
            json.dump(entries, log_file)
    else:
        with open(path, 'r', encoding='UTF-8') as log_file:
            entries = json.load(log_file)
        entries.append(new_entry)
        with open(path, 'w', encoding='UTF-8') as log_file:
            json.dump(entries, log_file)
