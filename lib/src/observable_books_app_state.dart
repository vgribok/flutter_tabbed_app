import 'package:flutter/material.dart';
import 'package:startup_namer/better_change_notifier.dart';
import 'models/book.dart';

class ObservableBooksAppState extends BetterChangeNotifier {
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
  set selectedTabIndex(int idx) => update(() => _selectedTabIndex = idx);

  Book? get selectedBook => _selectedBook;
  set selectedBook(Book? book) => update(() => _selectedBook = book);

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
  set appBarTitle(String? appBarTitle) => update(() => this._appBarTitle = appBarTitle ?? _defaultAppBarTitle);
}
