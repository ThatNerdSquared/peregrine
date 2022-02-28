from PySide6.QtWidgets import QVBoxLayout, QWidget
from peregrine.components.log_item_entry import LogItemEntry
from peregrine.generate_item_view import generate_item_view


class MainLogView(QWidget):
    """The main view that shows all logged items. Used as the default view"""
    def __init__(self, refresh):
        super().__init__()
        layout = QVBoxLayout()

        entries = generate_item_view()
        textentry = LogItemEntry(refresh)
        textentry.setMaximumHeight(100)

        layout.addWidget(entries)
        layout.addWidget(textentry)
        self.setLayout(layout)
