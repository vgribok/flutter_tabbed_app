/// It's a full navigation sample from https://gist.github.com/johnpryan/bbca91e23bbb4d39247fa922533be7c9

import 'package:flutter/material.dart';

void main() {
  runApp(NestedRouterDemo());
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class NestedRouterDemo extends StatefulWidget {
  @override
  _NestedRouterDemoState createState() => _NestedRouterDemoState();
}

class _NestedRouterDemoState extends State<NestedRouterDemo> {
  BookRouterDelegate _routerDelegate = BookRouterDelegate();
  BookRouteInformationParser _routeInformationParser =
  BookRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class BooksAppState extends ChangeNotifier {
  int _selectedIndex;
  static const _defaultAppBarTitle = 'Welcome to Book sample!';
  String _appBarTitle = _defaultAppBarTitle;
  Book? _selectedBook;

  final List<Book> _books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  BooksAppState() : _selectedIndex = 0;

  int get selectedTabIndex => _selectedIndex;

  set selectedTabIndex(int idx) {
    _selectedIndex = idx;
    if (_selectedIndex == 1) {
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

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'settings') {
      return BooksSettingsPath();
    } else {
      if (uri.pathSegments.length >= 2) {
        if (uri.pathSegments[0] == 'book') {
          return BooksDetailsPath(int.tryParse(uri.pathSegments[1])!);
        }
      }
      return BooksListPath();
    }
  }

  @override
  RouteInformation restoreRouteInformation(BookRoutePath configuration) {
    return RouteInformation(location: configuration.location);
  }
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final _appState = BooksAppState();

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    _appState.addListener(notifyListeners);
  }

  BookRoutePath get currentConfiguration {
    if (_appState.selectedTabIndex == 1) {
      return BooksSettingsPath();
    } else {
      if (_appState.selectedBook == null) {
        return BooksListPath();
      } else {
        return BooksDetailsPath(_appState.getSelectedBookById());
      }
    }
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
    if (path is BooksListPath) {
      _appState.selectedTabIndex = 0;
      _appState.selectedBook = null;
    } else if (path is BooksSettingsPath) {
      _appState.selectedTabIndex = 1;
    } else if (path is BooksDetailsPath) {
      _appState.setSelectedBookById(path.id);
    }
  }
}

// Routes
abstract class BookRoutePath {
  String get location;
}

class BooksListPath extends BookRoutePath {
  @override
  String get location => '/home';
}

class BooksSettingsPath extends BookRoutePath {
  @override
  String get location => '/settings';
}

class BooksDetailsPath extends BookRoutePath {
  final int id;

  BooksDetailsPath(this.id);

  @override
  String get location => '/book/$id';
}

// Widget that contains the AdaptiveNavigationScaffold
class AppShell extends StatefulWidget {
  final BooksAppState appState;

  AppShell({
    required this.appState,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  InnerRouterDelegate? _routerDelegate;
  ChildBackButtonDispatcher? _backButtonDispatcher;

  void initState() {
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate!.appState = widget.appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher!
        .createChildBackButtonDispatcher();
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

class InnerRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath>
{
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BooksAppState _appState;
  BooksAppState get appState => _appState;
  set appState(BooksAppState value) {
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
              books: appState._books,
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
  Future<void> setNewRoutePath(BookRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  void _handleBookTapped(Book book) {
    appState.selectedBook = book;
    notifyListeners();
  }
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({LocalKey? key, required this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}

// Screens
class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  BooksListScreen({
    required this.books,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => onTapped(book),
            )
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book? book;

  BookDetailsScreen({
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Go Back'),
            ),
            if (book != null) ...[
              Text(book!.title, style: Theme.of(context).textTheme.headline6),
              Text(book!.author, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings screen'),
      ),
    );
  }
}