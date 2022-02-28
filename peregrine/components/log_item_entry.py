from PySide6.QtGui import QKeySequence, QShortcut
from PySide6.QtWidgets import QHBoxLayout, QPushButton, QTextEdit, QWidget
from peregrine.add_item import add_log_item


class LogItemEntry(QWidget):
    """Lay out text entry box and button."""

    def __init__(self, refresh):
        super().__init__()

        self.refresh = refresh

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
        add_log_item(self.textbox.toMarkdown())
        self.refresh()
        self.textbox.clear()
        self.textbox.setFocus()
