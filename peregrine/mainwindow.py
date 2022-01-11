from PySide6.QtWidgets import QHBoxLayout, QLabel, QLineEdit, QMainWindow, QPushButton, QVBoxLayout, QWidget  # noqa: E501
from peregrine.add_item import add_log_item


class MainWindow(QMainWindow):
    """The main window for the app."""
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Peregrine")

        layout = QVBoxLayout()

        label = QLabel("Test")
        textentry = self.text_entry()

        layout.addWidget(label)
        layout.addWidget(textentry)
        widget = QWidget()
        widget.setLayout(layout)

        self.resize(500, 300)
        self.setCentralWidget(widget)

    def text_entry(self):
        """Lay out text entry box and button."""
        text_entry_layout = QHBoxLayout()

        self.textbox = QLineEdit()
        self.textbox.returnPressed.connect(self.add_item)
        log_button = QPushButton("Log")
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
