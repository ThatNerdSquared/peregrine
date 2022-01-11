from PySide6.QtWidgets import QApplication
from peregrine.mainwindow import MainWindow

app = QApplication([])
with open('style.qss', 'r') as qss_file:
    app.setStyleSheet(qss_file.read())

window = MainWindow()
window.show()

app.exec()
