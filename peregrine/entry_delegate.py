from PySide6.QtCore import QSize
from PySide6.QtGui import QAbstractTextDocumentLayout, QTextDocument
from PySide6.QtWidgets import QStyle, QStyleOptionViewItem, QStyledItemDelegate

from peregrine.config import Config


class EntryDelegate(QStyledItemDelegate):
    def paint(self, painter, option, index):
        style_option = QStyleOptionViewItem(option)
        self.initStyleOption(style_option, index)
        style = style_option.widget.style()

        doc = EntryDocument(style_option)
        ctx = QAbstractTextDocumentLayout.PaintContext()

        textRect = style.subElementRect(
            QStyle.SE_ItemViewItemText, style_option
        )
        painter.save()
        painter.translate(textRect.topLeft())
        doc.documentLayout().draw(painter, ctx)

        painter.restore()

    def sizeHint(self, option, index):
        style_option = QStyleOptionViewItem(option)
        self.initStyleOption(style_option, index)
        doc = EntryDocument(style_option)
        return QSize(
            int(doc.idealWidth()),
            int(doc.size().height())
        )


def EntryDocument(style_option):
    doc = QTextDocument()
    doc.setMarkdown(style_option.text)
    doc.setTextWidth(style_option.rect.width())
    doc.setDefaultFont(Config.ENTRY_FONT)
    return doc
