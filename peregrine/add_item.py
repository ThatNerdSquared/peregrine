from datetime import datetime

def add_log_item(input_text):
    """Adds a new entry to the log."""
    now = datetime.now()
    new_entry = {
        "date": now.isoformat(),
        "input": input_text
    }
    print(new_entry)
