import os
import sys
from datetime import datetime


def get_data_file_path(relative_path):
    try:
        base = sys._MEIPASS
    except Exception:
        base = os.path.abspath('.')

    return os.path.join(base, relative_path)


def get_formatted_date(input_date):
    raw_date = datetime.fromisoformat(input_date)
    date = raw_date.date()
    time = raw_date.time()
    formatted_date = date.isoformat()
    formatted_time = time.isoformat(timespec='seconds')

    return ''.join([formatted_date, '\n', formatted_time])
