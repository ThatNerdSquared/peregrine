from PySide6.QtCore import Signal
from PySide6.QtGui import QShortcut, QTextDocument
from PySide6.QtWidgets import QHBoxLayout, QPlainTextEdit, QPushButton, QWidget
from peregrine.config import Config, Keybinds
from peregrine.data_store import DataStore


class LogItemEntry(QWidget):
    """Lay out text entry box and button."""
    TEXTENTRY_RESIZE = Signal(dict)

    def __init__(self, entry_model, view, mainwindow):
        super().__init__()

        self.MODEL = entry_model
        self.VIEW = view
        self.MAINWINDOW = mainwindow

        text_entry_layout = QHBoxLayout()

        self.textbox = QPlainTextEdit()
        self.textbox.textChanged.connect(
            self.fit_height
        )
        self.textbox.cursorPositionChanged.connect(
            self.fit_height
        )
        self.fit_height()
        enter_key_shortcut = QShortcut(
            Keybinds.ADD_ENTRY,
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

    def fit_height(self):
        measurements = self.get_text_sizing(self.textbox)
        new_height = measurements['height']
        if new_height < (self.MAINWINDOW.frameGeometry().height() * 0.4):
            height_to_set = new_height
        else:
            height_to_set = self.MAINWINDOW.frameGeometry().height() * 0.4
        self.textbox.resize(
            measurements['width'],
            height_to_set
        )
        self.resize(self.width(), self.textbox.size().height() + 30)
        self.TEXTENTRY_RESIZE.emit(height_to_set + 30)

    def get_text_sizing(self, entrybox):
        doc = QTextDocument()
        doc.setPlainText(entrybox.toPlainText())
        doc.setTextWidth(entrybox.rect().width())
        doc.setDefaultFont(Config.ENTRY_FONT)

        width = entrybox.width()
        height = doc.size().height() + 30
        return {'width': width, 'height': height}
