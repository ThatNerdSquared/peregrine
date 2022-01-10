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
        self.textbox = QLineEdit()
        text_entry_layout.addWidget(self.textbox)
        self.textbox.returnPressed.connect(self.add_button_clicked)

        log_button = QPushButton("Log")
        log_button.setCheckable(True)
        text_entry_layout.addWidget(log_button)
        log_button.clicked.connect(self.add_button_clicked)


        text_entry = QWidget()
        text_entry.setLayout(text_entry_layout)
        layout.addWidget(text_entry)

        widget = QWidget()
        widget.setLayout(layout)

        self.setCentralWidget(widget)

    def add_button_clicked(self):
        print(self.textbox.text())

app = QApplication([])

window = MainWindow()
window.show()


app.exec()
