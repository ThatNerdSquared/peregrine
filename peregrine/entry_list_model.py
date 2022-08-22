from PySide6.QtCore import QAbstractTableModel, Qt
from peregrine import utils
from peregrine.config import Config


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
                            self.entries[index.row()].date
                        )
                    case 1:
                        value = self.entries[index.row()].input
                return value
            case Qt.TextAlignmentRole:
                return Qt.AlignTop
            case Qt.FontRole:
                match index.column():
                    case 0:
                        return Config.DATE_FONT
                    case 1:
                        return Config.ENTRY_FONT

    def rowCount(self, index=None):
        return len(self.entries)

    def columnCount(self, index=None):
        return 2
