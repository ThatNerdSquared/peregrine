from PySide6.QtCore import Qt
from PySide6.QtWidgets import QAbstractItemView, QFrame, QHeaderView, QSizePolicy, QTableView, QVBoxLayout, QWidget  # noqa: E501
from peregrine.data_store import DataStore
from peregrine.entry_delegate import EntryDelegate
from peregrine.entry_list_model import EntryListModel
from peregrine.log_item_entry import LogItemEntry
from peregrine.search_box import SearchBox


class MainLogView(QWidget):
    """The main view that shows all logged items. Used as the default view"""
    def __init__(self, mainwindow):
        super().__init__()
        self.MAINWINDOW = mainwindow
        layout = QVBoxLayout()
        DS = DataStore()
        self.master_entries_list = []
        for item in DS.read_data():
            self.master_entries_list.append(item['input'].lower())

        entry_model = EntryListModel(entries=DS.read_data())
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
        entries.setSizePolicy(QSizePolicy.Preferred, QSizePolicy.Preferred)

        self.textentry = LogItemEntry(entry_model, entries, self.MAINWINDOW)
        self.textentry.setSizePolicy(
            QSizePolicy.Preferred,
            QSizePolicy.MinimumExpanding,
        )
        self.textentry.setMaximumHeight(
            self.textentry.textbox.size().height() + 30
        )
        self.textentry.TEXTENTRY_RESIZE.connect(
            lambda x: self.textentry.setMaximumHeight(x)
        )

        search_box = SearchBox(entries, self.master_entries_list)
        search_box.setSizePolicy(QSizePolicy.Preferred, QSizePolicy.Fixed)
        layout.addWidget(search_box)
        layout.addWidget(entries)
        layout.addWidget(self.textentry)

        self.setLayout(layout)
