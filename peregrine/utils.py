import sys
from datetime import datetime
from pathlib import Path


def get_data_file_path(relative_path):
    try:
        base = Path(sys._MEIPASS)
    except Exception:
        base = Path('.').resolve()

    return base / Path(relative_path)


def get_formatted_date(input_date):
    raw_date = datetime.fromisoformat(input_date)
    date = raw_date.date()
    time = raw_date.time()
    formatted_date = date.isoformat()
    formatted_time = time.isoformat(timespec='seconds')

    return ''.join([formatted_date, '\n', formatted_time])
