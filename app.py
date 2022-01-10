from PySide6.QtCore import QSize, Qt
from PySide6.QtWidgets import QApplication, QLineEdit, QMainWindow, QPushButton, QVBoxLayout, QWidget

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Peregrine")

        layout = QVBoxLayout()


        layout.addWidget(QLineEdit())
        layout.addWidget(QPushButton("Log"))

        widget = QWidget()
        widget.setLayout(layout)

        self.setCentralWidget(widget)

app = QApplication([])

window = MainWindow()
window.show()


app.exec()
