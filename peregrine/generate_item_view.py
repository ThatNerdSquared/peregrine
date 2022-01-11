from datetime import datetime
import os
import json

from PySide6.QtWidgets import QHBoxLayout, QLabel, QVBoxLayout, QWidget
from peregrine.config import Config


def generate_item_view():
    path = "".join([str(Config.LOG_PATH), 'peregrinelog.json'])
    if not os.path.exists(path):
        label = QLabel("No entries have been logged yet.")
        return label
    else:
        with open(path, 'r', encoding='UTF-8') as log_file:
            entries = json.load(log_file)

        entry_rows_layout = QVBoxLayout()

        for entry in entries:
            item_layout = QHBoxLayout()

            raw_date = datetime.fromisoformat(entry['date'])
            date = raw_date.date()
            time = raw_date.time()
            formatted_date = date.isoformat()
            formatted_time = time.isoformat(timespec="seconds")

            datetime_layout = QVBoxLayout()
            datetime_layout.addWidget(QLabel(formatted_date))
            datetime_layout.addWidget(QLabel(formatted_time))

            item_layout.addLayout(datetime_layout)
            item_layout.addWidget(QLabel(entry['input']))

            entry_rows_layout.addLayout(item_layout)

        entry_rows = QWidget()
        entry_rows.setLayout(entry_rows_layout)

        return entry_rows
