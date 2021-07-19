/// It's a full navigation sample from https://gist.github.com/johnpryan/bbca91e23bbb4d39247fa922533be7c9

import 'package:flutter/material.dart';
import 'package:startup_namer/src/models/book.dart';
import 'package:startup_namer/src/navigation/route_parsing_factory.dart';
import 'package:startup_namer/src/routes/route_path.dart';
import 'package:startup_namer/src/routes/books_detail_path.dart';
import 'package:startup_namer/src/routes/books_list_path.dart';
import 'package:startup_namer/src/routes/settings_path.dart';
import 'package:startup_namer/src/screens/book_details_screen.dart';
import 'package:startup_namer/src/screens/books_list_screen.dart';
import 'package:startup_namer/src/screens/settinsg_screen.dart';
import 'fade_animation_page.dart';
import 'src/observable_books_app_state.dart';

void main() {
  runApp(NestedRouterDemoApp());
}

class NestedRouterDemoApp extends StatefulWidget {
  @override
  _NestedRouterDemoAppState createState() => _NestedRouterDemoAppState();
}

class _NestedRouterDemoAppState extends State<NestedRouterDemoApp> {
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

class BookRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final _appState = ObservableBooksAppState();

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    _appState.addListener(notifyListeners);
  }

  RoutePath get currentConfiguration {
    if (_appState.selectedTabIndex == 1) return SettingsPath();

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
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {

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
    _routerDelegate = InnerRouterDelegate<RoutePath>(widget.appState);
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: appState.selectedTabIndex,
        onTap: (newTabIndex) {
          appState.selectedTabIndex = newTabIndex;
        },
      ),
    );
  }
}

class InnerRouterDelegate<TRoute> extends RouterDelegate<TRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<TRoute>
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

    List<Page<dynamic>> pages = _homePage(appState);
    var settingsPage = _settingsPage();

    if (appState.selectedTabIndex == 0)
      pages.insert(0, settingsPage); // Last page in nav stack, "Home", will be shown
    else
      pages.add(settingsPage); // Last page in nav stack, "Settings" will be shown

    return Navigator(
      key: navigatorKey,
      pages: pages,

      onPopPage: (route, result) {
        if(!route.didPop(result)) {
          return false;
        }

        var page = route.settings as MaterialPage;

        // TODO: use OOP polymorphism instead of 'if type is'
        if(page.child is BookDetailsScreen) {
          appState.selectedBook = null;
          notifyListeners();
        }
        else {
          appState.selectedTabIndex = 1 - appState.selectedTabIndex;
          notifyListeners();
        }
        return true;
      },
    );
  }

  Page<dynamic> _settingsPage() =>
    MaterialPage(
      child: SettingsScreen(),
      key: ValueKey('SettingsPage'),
    );

  List<Page<dynamic>> _homePage(ObservableBooksAppState appState) {
    List<Page<dynamic>> pages = [
      MaterialPage(
        child: BooksListScreen(
          books: appState.books,
          onTapped: _handleBookTapped,
        ),
        key: ValueKey('BooksListPage'),
      )
    ];

    if (appState.selectedBook != null) {
      pages.add(MaterialPage(
        key: ValueKey(appState.selectedBook),
        child: BookDetailsScreen(book: appState.selectedBook),
      ));
    }

    return pages;
  }

  @override
  Future<void> setNewRoutePath(TRoute path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  void _handleBookTapped(Book book) {
    appState.selectedBook = book;
    notifyListeners();
  }
}
