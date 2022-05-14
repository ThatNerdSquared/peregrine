from PySide6.QtWidgets import QLineEdit, QVBoxLayout, QWidget
from thefuzz import process


class SearchBox(QWidget):
    def __init__(self, table, master_list):
        super().__init__()
        self.TABLE = table
        self.MASTER_LIST = master_list
        self.matches = []
        self.current_match = 0
        main_layout = QVBoxLayout()

        self.search_box = QLineEdit()
        self.search_box.setPlaceholderText('Search...')
        self.search_box.textChanged.connect(self.search)
        self.search_box.returnPressed.connect(self.next_item)

        main_layout.addWidget(self.search_box)
        self.setLayout(main_layout)

    def search(self):
        self.current_match = 0
        user_input = self.search_box.text()
        self.matches = process.extract(user_input, self.MASTER_LIST)
        print(self.matches)
        self.TABLE.selectRow(self.matches[self.current_match][1])

    def next_item(self):
        self.current_match += 1
        self.TABLE.selectRow(self.matches[self.current_match][1])

    def previous_item(self):
        self.current_match -= 1
        self.TABLE.selectRow(self.matches[self.current_match][1])
