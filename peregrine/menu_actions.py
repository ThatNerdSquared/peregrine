from PySide6.QtGui import QAction, QKeySequence


class MenuActions():
    def __init__(
        self,
        main_window,
        menu_bar,
        search_box,
        entry_table,
        textentry
    ):
        super().__init__()
        self.SEARCH_BOX = search_box
        self.ENTRY_TABLE = entry_table
        self.TEXTENTRY = textentry

        search_action = QAction('Find', main_window)
        search_action.triggered.connect(
            lambda: self.SEARCH_BOX.search_box.setFocus()
        )
        search_action.setShortcut(QKeySequence('Ctrl+F'))

        focus_list_action = QAction('Focus Log', main_window)
        focus_list_action.triggered.connect(
            lambda: self.ENTRY_TABLE.setFocus()
        )
        focus_list_action.setShortcut(QKeySequence('Ctrl+\\'))

        new_entry_action = QAction('New Entry', main_window)
        new_entry_action.triggered.connect(
            lambda: self.TEXTENTRY.textbox.setFocus()
        )
        new_entry_action.setShortcut(QKeySequence('Ctrl+N'))

        file_menu = menu_bar.addMenu('&File')
        file_menu.addAction(new_entry_action)
        edit_menu = menu_bar.addMenu('&Edit')
        edit_menu.addAction(search_action)
        view_menu = menu_bar.addMenu('&View')
        view_menu.addAction(focus_list_action)
