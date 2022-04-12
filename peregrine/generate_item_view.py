import json
from PySide6.QtWidgets import QLabel, QVBoxLayout, QWidget
from peregrine.config import Config
from peregrine.entry import Entry


class LogScroll(QWidget):
    def __init__(self):
        super().__init__()
        log_rows_layout = QVBoxLayout()

        try:
            entries = json.loads(Config.LOG_PATH.read_text())
            for entry in entries:
                item = Entry(entry['date'], entry['input'])
                log_rows_layout.addWidget(item)
        except FileNotFoundError:
            nonexistent_log_label = QLabel('No entries have been logged yet.')
            nonexistent_log_label.setObjectName('nonexistent_log_label')
            log_rows_layout.addWidget(nonexistent_log_label)
            return self.setLayout(log_rows_layout)

        self.setLayout(log_rows_layout)
        self.setObjectName('entryview')
