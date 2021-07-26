import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';
import 'package:startup_namer/src/models/book.dart';

class BooksListScreen extends TabbedNavScreen {

  static const int navTabIndex = 0;

  static final ValueNotifier<Book?> selectedBook = ValueNotifier(null);

  static int get selectedBookId => selectedBook.value == null ? -1 : books.indexOf(selectedBook.value!);
  static set selectedBookId(int bookId) => selectedBook.value = books[bookId];

  static final List<Book> books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  BooksListScreen() : super(
      pageTitle: 'Books',
      tabIndex: navTabIndex
  );

  @override
  Widget buildBody(BuildContext context) =>
      ListView(
          children: [
            for (var book in books)
              ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => selectedBook.value = book,
              )
          ]
      );

  static bool isValidBookId(int bookId) {
    return bookId >= 0 && bookId < books.length;
  }
}
