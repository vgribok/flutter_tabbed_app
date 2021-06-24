import 'package:flutter/material.dart';
import 'models/book.dart';

class ObservableBooksAppState extends ChangeNotifier {
  int _selectedTabIndex;
  static const _defaultAppBarTitle = 'Welcome to Book sample!';
  String _appBarTitle = _defaultAppBarTitle;
  Book? _selectedBook;

  final List<Book> _books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];
  List<Book> get books => _books;

  ObservableBooksAppState() : _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;

  set selectedTabIndex(int idx) {
    _selectedTabIndex = idx;
    if (_selectedTabIndex == 1) {
      // Remove this line if you want to keep the selected book when navigating
      // between "settings" and "home" which book was selected when Settings is
      // tapped.
      selectedBook = null;
    }
    notifyListeners();
  }

  Book? get selectedBook => _selectedBook;

  set selectedBook(Book? book) {
    _selectedBook = book;
    notifyListeners();
  }

  int getSelectedBookById() {
    if (!_books.contains(_selectedBook)) return 0;
    return _books.indexOf(_selectedBook!);
  }

  void setSelectedBookById(int id) {
    if (id < 0 || id > _books.length - 1) {
      return;
    }

    _selectedBook = _books[id];
    notifyListeners();
  }

  String get appBarTitle => _appBarTitle;

  set appBarTitle(String? appBarTitle) {
    this._appBarTitle = appBarTitle ?? _defaultAppBarTitle;
    notifyListeners();
  }
}
