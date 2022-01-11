from PySide6.QtCore import QSize
from PySide6.QtWidgets import QHBoxLayout, QLineEdit, QMainWindow, QPushButton, QVBoxLayout, QWidget  # noqa: E501
from peregrine.add_item import add_log_item
from peregrine.generate_item_view import generate_item_view


class MainWindow(QMainWindow):
    """The main window for the app."""
    def __init__(self):
        super().__init__()

        self.setMinimumSize(QSize(300, 200))
        self.set_up_window()

    def set_up_window(self):
        self.setWindowTitle("Peregrine")

        layout = QVBoxLayout()

        entries = generate_item_view()
        textentry = self.text_entry()

        layout.addWidget(entries)
        layout.addWidget(textentry)
        widget = QWidget()
        widget.setLayout(layout)

        self.setCentralWidget(widget)

    def text_entry(self):
        """Lay out text entry box and button."""
        text_entry_layout = QHBoxLayout()

        self.textbox = QLineEdit()
        self.textbox.returnPressed.connect(self.add_item)
        log_button = QPushButton("Log")
        log_button.setEnabled(True)
        log_button.clicked.connect(self.add_item)

        text_entry_layout.addWidget(self.textbox)
        text_entry_layout.addWidget(log_button)
        text_entry = QWidget()
        text_entry.setLayout(text_entry_layout)

        return text_entry

    def add_item(self):
        """Handle submitted text in textbox."""
        add_log_item(self.textbox.text())
        self.textbox.clear()
        self.set_up_window()
        self.textbox.setFocus()
