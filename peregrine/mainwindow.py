import darkdetect
from PySide6.QtCore import QCoreApplication, QDir, QSize, Qt
from PySide6.QtGui import QIcon, QFontDatabase  # noqa: E501
from PySide6.QtWidgets import QApplication, QMainWindow  # noqa: E501
import platform
from peregrine.main_log_view import MainLogView
from peregrine.utils import get_data_file_path


class MainWindow(QMainWindow):
    """The main window for the app."""
    def __init__(self):
        super().__init__()

        self.setMinimumSize(QSize(450, 200))
        self.set_up_window()

    def set_up_window(self):
        self.setWindowTitle("Peregrine")
        widget = MainLogView(self.refresh_event)
        self.setCentralWidget(widget)

    def refresh_event(self):
        self.set_up_window()


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
