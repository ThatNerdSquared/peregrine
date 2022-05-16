from PySide6.QtGui import QShortcut
from PySide6.QtWidgets import QLineEdit, QVBoxLayout, QWidget

from peregrine.config import Keybinds


class SearchBox(QWidget):
    def __init__(self, table):
        super().__init__()
        self.TABLE = table
        self.user_input = ''
        self.matches = []
        self.current_match = 0
        main_layout = QVBoxLayout()

        self.search_box = QLineEdit()
        self.search_box.setPlaceholderText('Search...')
        self.search_box.returnPressed.connect(self.search)
        previous_item_keybind = QShortcut(
            Keybinds.PREVIOUS_ITEM,
            self.search_box
        )
        previous_item_keybind.activated.connect(self.previous_item)

        main_layout.addWidget(self.search_box)
        self.setLayout(main_layout)

    def search(self):
        if self.user_input == self.search_box.text().lower():
            self.current_match += 1
            self.TABLE.clearSelection()
            try:
                self.TABLE.selectRow(self.matches[self.current_match])
            except IndexError:
                self.current_match = 0
                self.TABLE.selectRow(self.matches[self.current_match])
        else:
            self.matches = []
            self.current_match = 0
            self.user_input = self.search_box.text().lower()
            idx = 0
            for item in self.TABLE.model().entries:
                if self.user_input in item['input'].lower():
                    self.matches.append(idx)
                idx += 1
            self.TABLE.selectRow(self.matches[self.current_match])

    def previous_item(self):
        self.current_match -= 1
        self.TABLE.clearSelection()
        try:
            self.TABLE.selectRow(self.matches[self.current_match])
        except IndexError:
            self.current_match = -1
            self.TABLE.selectRow(self.matches[self.current_match])
