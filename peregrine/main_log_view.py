from PySide6.QtCore import Qt
from PySide6.QtWidgets import QFrame, QScrollArea, QVBoxLayout, QWidget
from peregrine.log_item_entry import LogItemEntry
from peregrine.generate_item_view import LogScroll


class MainLogView(QWidget):
    """The main view that shows all logged items. Used as the default view"""
    def __init__(self, refresh):
        super().__init__()
        layout = QVBoxLayout()

        log_scroll = LogScroll()

        scroll_area = QScrollArea()
        scroll_area.setFrameShape(QFrame.NoFrame)
        scroll_area.setWidget(log_scroll)
        scroll_area.setWidgetResizable(True)
        scroll_area.setMinimumWidth(300)
        scroll_area.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        scroll_area.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        scroll_area.setEnabled(True)
        bar = scroll_area.verticalScrollBar()
        bar.rangeChanged.connect(lambda x, y: bar.setValue(y))

        textentry = LogItemEntry(refresh)
        textentry.setMaximumHeight(100)

        layout.addWidget(scroll_area)
        layout.addWidget(textentry)

        self.setLayout(layout)
