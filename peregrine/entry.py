from datetime import datetime
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QHBoxLayout, QLabel, QWidget


class Entry(QWidget):
    def __init__(self, DATE, ENTRY):
        super().__init__()
        item_layout = QHBoxLayout()

        raw_date = datetime.fromisoformat(DATE)
        date = raw_date.date()
        time = raw_date.time()
        formatted_date = date.isoformat()
        formatted_time = time.isoformat(timespec='seconds')

        datetime_text = ''.join([formatted_date, '\n', formatted_time])
        date_and_time = QLabel(datetime_text)
        date_and_time.setObjectName('datetimetext')

        entry_text = QLabel(ENTRY)

        entry_text.setTextInteractionFlags(Qt.TextSelectableByMouse)
        entry_text.setTextInteractionFlags(Qt.LinksAccessibleByMouse)
        entry_text.setTextFormat(Qt.MarkdownText)
        entry_text.setOpenExternalLinks(True)

        entry_text.setObjectName('entrytext')
        entry_text.setWordWrap(True)
        entry_text.setMinimumWidth(300)

        item_layout.addWidget(date_and_time, alignment=Qt.AlignTop)
        item_layout.addWidget(entry_text, alignment=Qt.AlignTop)
        item_layout.setAlignment(Qt.AlignLeft)

        self.setLayout(item_layout)
