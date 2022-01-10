from PySide6.QtCore import QSize, Qt
from PySide6.QtWidgets import QApplication, QHBoxLayout, QLabel, QLineEdit, QMainWindow, QPushButton, QVBoxLayout, QWidget

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Peregrine")

        layout = QVBoxLayout()

        label = QLabel("Test")
        layout.addWidget(label)

        text_entry_layout = QHBoxLayout()

        text_entry_layout.addWidget(QLineEdit())
        text_entry_layout.addWidget(QPushButton("Log"))

        text_entry = QWidget()
        text_entry.setLayout(text_entry_layout)
        layout.addWidget(text_entry)

        widget = QWidget()
        widget.setLayout(layout)

        self.setCentralWidget(widget)

app = QApplication([])

window = MainWindow()
window.show()


app.exec()
