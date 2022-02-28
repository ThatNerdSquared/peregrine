import darkdetect
from PySide6.QtCore import QCoreApplication, QDir, QSize, Qt
from PySide6.QtGui import QIcon, QFontDatabase, QKeySequence, QShortcut  # noqa: E501
from PySide6.QtWidgets import QApplication, QHBoxLayout, QMainWindow, QPushButton, QTextEdit, QVBoxLayout, QWidget  # noqa: E501
import platform
from peregrine.add_item import add_log_item
from peregrine.generate_item_view import generate_item_view
from peregrine.utils import get_data_file_path


class MainWindow(QMainWindow):
    """The main window for the app."""
    def __init__(self):
        super().__init__()

        if (platform.system() == 'Windows'):
            windowsicon_path = get_data_file_path('peregrine-icon.png')
            self.setWindowIcon(QIcon(windowsicon_path))

        self.setMinimumSize(QSize(450, 200))
        self.set_up_window()

    def set_up_window(self):
        self.setWindowTitle("Peregrine")

        layout = QVBoxLayout()

        entries = generate_item_view()
        textentry = self.text_entry()
        textentry.setMaximumHeight(100)

        layout.addWidget(entries)
        layout.addWidget(textentry)
        widget = QWidget()
        widget.setLayout(layout)

        self.setCentralWidget(widget)

    def text_entry(self):
        """Lay out text entry box and button."""
        text_entry_layout = QHBoxLayout()

        self.textbox = QTextEdit()
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
        text_entry = QWidget()
        text_entry.setLayout(text_entry_layout)

        return text_entry

    def add_item(self):
        """Handle submitted text in textbox."""
        add_log_item(self.textbox.toMarkdown())
        self.textbox.clear()
        self.set_up_window()
        self.textbox.setFocus()


def main():
    app = QApplication([])

    # Windows optimizations.
    if (platform.system() == 'Windows'):
        windowsicon_path = get_data_file_path('peregrine-icon.png')
        app.setWindowIcon(QIcon(windowsicon_path))

        fonts = get_data_file_path('fonts')
        for font in QDir(fonts).entryInfoList("*.ttf"):
            QFontDatabase.addApplicationFont(font.absoluteFilePath())

    # Styling.
    if darkdetect.isDark():
        stylesheet_path = get_data_file_path('dark-academia.qss')
    else:
        stylesheet_path = get_data_file_path('light-academia.qss')
    with open(stylesheet_path, 'r') as qss_file:
        app.setStyleSheet(qss_file.read())

    window = MainWindow()
    window.show()
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
    app.exec()


if __name__ == '__main__':
    main()
