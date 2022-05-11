from PySide6.QtGui import QKeySequence, QShortcut
from PySide6.QtWidgets import QHBoxLayout, QPushButton, QTextEdit, QWidget
from peregrine.data_store import DataStore


class LogItemEntry(QWidget):
    """Lay out text entry box and button."""

    def __init__(self, entry_model, view):
        super().__init__()

        self.MODEL = entry_model
        self.VIEW = view

        text_entry_layout = QHBoxLayout()

        self.textbox = QTextEdit()
        self.textbox.setFocus()
        enter_key_shortcut = QShortcut(
            QKeySequence('Ctrl+Return'),
            self.textbox
        )
        enter_key_shortcut.activated.connect(self.add_item)
        log_button = QPushButton("Log")
        log_button.setEnabled(True)
        log_button.clicked.connect(self.add_item)

        text_entry_layout.addWidget(self.textbox)
        text_entry_layout.addWidget(log_button)
        self.setLayout(text_entry_layout)

    def add_item(self):
        """Handle submitted text in textbox."""
        input = self.textbox.toPlainText().strip()
        if input:
            DataStore().add_log_item(input, self.MODEL)
            self.MODEL.layoutChanged.emit()
            self.textbox.clear()
        self.VIEW.scrollToBottom()
        self.textbox.setFocus()
