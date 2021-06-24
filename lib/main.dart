/// It's a full navigation sample from https://gist.github.com/johnpryan/bbca91e23bbb4d39247fa922533be7c9

import 'package:flutter/material.dart';
import 'package:startup_namer/src/models/book.dart';
import 'package:startup_namer/src/navigation/route_parsing_factory.dart';
import 'package:startup_namer/src/routes/book_route_path.dart';
import 'package:startup_namer/src/routes/books_detail_path.dart';
import 'package:startup_namer/src/routes/books_list_path.dart';
import 'package:startup_namer/src/routes/books_settings_path.dart';
import 'package:startup_namer/src/screens/book_details_screen.dart';
import 'package:startup_namer/src/screens/books_list_screen.dart';
import 'package:startup_namer/src/screens/settinsg_screen.dart';
import 'fade_animation_page.dart';
import 'src/observable_books_app_state.dart';

void main() {
  runApp(NestedRouterDemo());
}

class NestedRouterDemo extends StatefulWidget {
  @override
  _NestedRouterDemoState createState() => _NestedRouterDemoState();
}

class _NestedRouterDemoState extends State<NestedRouterDemo> {
  final BookRouterDelegate _routerDelegate = BookRouterDelegate();
  final RouteParsingFactory _routeInformationParser =  RouteParsingFactory();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final _appState = ObservableBooksAppState();

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    _appState.addListener(notifyListeners);
  }

  BookRoutePath get currentConfiguration {
    if (_appState.selectedTabIndex == 1) return BooksSettingsPath();

    return _appState.selectedBook == null ?
            BooksListPath() : BooksDetailsPath(_appState.getSelectedBookById());
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: AppShell(appState: _appState),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (_appState.selectedBook != null) {
          _appState.selectedBook = null;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {

    _appState.selectedTabIndex = path.selectedTabIndex;
    _appState.appBarTitle = path.appBarTitle;

    if (path is BooksListPath) {
      _appState.selectedBook = null;
    } else if (path is BooksDetailsPath) {
      _appState.setSelectedBookById(path.id);
    }
  }
}

// Widget that contains the AdaptiveNavigationScaffold
class AppShell extends StatefulWidget {
  final ObservableBooksAppState appState;

  AppShell({
    required this.appState,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

abstract class NavigableState<T extends StatefulWidget> extends State<T> {

  InnerRouterDelegate? _routerDelegate;
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher!.createChildBackButtonDispatcher();
  }
}

class _AppShellState extends NavigableState<AppShell> {

  @override
  void initState() {
    super.initState();
    _routerDelegate = InnerRouterDelegate<BookRoutePath>(widget.appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate!.appState = widget.appState;
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher?.takePriority();

    return Scaffold(
      appBar: AppBar(title: Text(appState.appBarTitle)),
      body: Router(
        routerDelegate: _routerDelegate!,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: appState.selectedTabIndex,
        onTap: (newTabIndex) {
          appState.selectedTabIndex = newTabIndex;
        },
      ),
    );
  }
}

class InnerRouterDelegate<T> extends RouterDelegate<T>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<T>
{
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ObservableBooksAppState _appState;
  ObservableBooksAppState get appState => _appState;
  set appState(ObservableBooksAppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.selectedTabIndex == 0) ...[
          FadeAnimationPage(
            child: BooksListScreen(
              books: appState.books,
              onTapped: _handleBookTapped,
            ),
            key: ValueKey('BooksListPage'),
          ),
          if (appState.selectedBook != null)
            MaterialPage(
              key: ValueKey(appState.selectedBook),
              child: BookDetailsScreen(book: appState.selectedBook),
            ),
        ] else
          FadeAnimationPage(
            child: SettingsScreen(),
            key: ValueKey('SettingsPage'),
          ),
      ],
      onPopPage: (route, result) {
        appState.selectedBook = null;
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(T path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  void _handleBookTapped(Book book) {
    appState.selectedBook = book;
    notifyListeners();
  }
}
