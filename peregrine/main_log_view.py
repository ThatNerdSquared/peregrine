from PySide6.QtCore import Qt
from PySide6.QtWidgets import QAbstractItemView, QFrame, QHeaderView, QTableView, QVBoxLayout, QWidget  # noqa: E501
from peregrine.data_store import DataStore
from peregrine.entry_delegate import EntryDelegate
from peregrine.entry_list_model import EntryListModel
from peregrine.log_item_entry import LogItemEntry


class MainLogView(QWidget):
    """The main view that shows all logged items. Used as the default view"""
    def __init__(self):
        super().__init__()
        layout = QVBoxLayout()

        entry_model = EntryListModel(entries=DataStore().read_data())
        entries = QTableView()
        entries.setModel(entry_model)
        entries.setItemDelegateForColumn(1, EntryDelegate())
        entries.setSelectionBehavior(QAbstractItemView.SelectRows)

        entries.horizontalHeader().setStretchLastSection(True)
        entries.verticalHeader().setSectionResizeMode(
            QHeaderView.ResizeToContents
        )
        entries.horizontalHeader().setSectionResizeMode(
            QHeaderView.ResizeToContents
        )

        entries.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        entries.setVerticalScrollMode(QAbstractItemView.ScrollPerPixel)
        entries.setHorizontalScrollMode(QAbstractItemView.ScrollPerPixel)

        entries.setFrameShape(QFrame.NoFrame)
        entries.setShowGrid(False)
        entries.horizontalHeader().setVisible(False)
        entries.verticalHeader().setVisible(False)
        entries.scrollToBottom()

        textentry = LogItemEntry(entry_model, entries)
        textentry.setMaximumHeight(100)

        layout.addWidget(entries)
        layout.addWidget(textentry)

        self.setLayout(layout)
