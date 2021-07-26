import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';
import 'package:startup_namer/src/models/book.dart';

class BookDetailsScreen extends TabbedNavScreen {
  static const navTabIndex = 0;

  final Book book;

  BookDetailsScreen({
    required this.book,
    required TabNavState navState
  }) : super(
    pageTitle: book.title,
    tabIndex: navTabIndex,
    navState: navState
  );

  @override
  ValueKey get key => ValueKey(book);

  @override
  Widget buildBody(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Text(book.title, style: Theme.of(context).textTheme.headline6),
              Text(book.author, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      );
}