from datetime import datetime
import os
import json

from PySide6.QtCore import Qt
from PySide6.QtWidgets import QHBoxLayout, QLabel, QScrollArea, QVBoxLayout, QWidget  # noqa: E501
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
        entry_rows_layout.setSpacing(30)

        for entry in entries:
            item_layout = QHBoxLayout()

            raw_date = datetime.fromisoformat(entry['date'])
            date = raw_date.date()
            time = raw_date.time()
            formatted_date = date.isoformat()
            formatted_time = time.isoformat(timespec="seconds")

            datetime_layout = QVBoxLayout()
            datetime_layout.setSpacing(0)
            datetime_layout.addWidget(QLabel(formatted_date))
            datetime_layout.addWidget(QLabel(formatted_time))

            entry_text = QLabel(entry['input'])
            entry_text.setWordWrap(True)

            item_layout.addLayout(datetime_layout)
            item_layout.addWidget(entry_text, alignment=Qt.AlignLeft)
            item_layout.setAlignment(Qt.AlignLeft)

            entry_rows_layout.addLayout(item_layout)

        entry_rows = QWidget()
        entry_rows.setLayout(entry_rows_layout)

        scroll_area = QScrollArea()
        scroll_area.setWidget(entry_rows)
        bar = scroll_area.verticalScrollBar()
        bar.rangeChanged.connect(lambda x, y: bar.setValue(y))

        return scroll_area
