from PySide6.QtCore import QAbstractTableModel, Qt
from PySide6.QtGui import QFont
from peregrine import utils


class EntryListModel(QAbstractTableModel):
    def __init__(self, entries=None):
        super().__init__()
        self.entries = entries or []

    def data(self, index, role):
        match role:
            case Qt.DisplayRole:
                value = ""
                match index.column():
                    case 0:
                        value = utils.get_formatted_date(
                            self.entries[index.row()]['date']
                        )
                    case 1:
                        value = self.entries[index.row()]['input']
                return value
            case Qt.TextAlignmentRole:
                return Qt.AlignTop
            case Qt.FontRole:
                font = QFont('Spectral')
                match index.column():
                    case 0:
                        font.setPointSize(14)
                    case 1:
                        font.setPointSize(16)
                return font

    def rowCount(self, index=None):
        return len(self.entries)

    def columnCount(self, index=None):
        return 2
