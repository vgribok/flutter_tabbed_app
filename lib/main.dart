import 'package:flutter/material.dart';
import 'package:startup_namer/404_nav_screen.dart';
import 'package:startup_namer/tab_nav_state.dart';
import 'package:startup_namer/tabbed_nav_screen.dart';

void main() {
  runApp(BooksApp());
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  BookRouterDelegate _routerDelegate = BookRouterDelegate();
  BetterRouterInfoParser _routeInformationParser =  BetterRouterInfoParser(
    routeParsers: [
      BookListPath.fromUri,
      BookDetailPath.fromUri,
      SettingsPath.fromUri
    ]
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

typedef RoutePathFactory = RoutePath? Function(Uri);

class BetterRouterInfoParser extends RouteInformationParser<RoutePath> {

  final List<RoutePathFactory> routeParsers;

  BetterRouterInfoParser({required this.routeParsers});

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    for(RoutePathFactory routePathFactory in routeParsers) {
      RoutePath? path = routePathFactory(uri);
      if(path != null)
        return Future.value(path);
    }

    return Future.value(NotFoundRoutePath(uri: uri));
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath path) => path.routeInformation;
}

class BookRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>()
  {
    BooksListScreen.selectedBook.addListener(notifyListeners);

    TabbedNavScreen.navState = TabNavState(tabs: [
      TabInfo(id: 'Books', icon: Icons.home, title: 'Books'),
      TabInfo(id: 'Settings', icon: Icons.settings, title: 'Settings')
    ]);
    TabbedNavScreen.navState!.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {

    return Navigator(
      key: navigatorKey,
      //transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        if(TabbedNavScreen.navState!.selectedTabIndex == 1)
          SettingsScreen().page
        else
          ...[
            BooksListScreen().page,
            if (BooksListScreen.selectedBook.value != null)
              BookDetailsScreen(book: BooksListScreen.selectedBook.value!).page
          ],
        if(TabbedNavScreen.navState!.notFoundUri != null)
          UrlNotFoundScreen().page
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if(TabbedNavScreen.navState!.notFoundUri != null) {
          TabbedNavScreen.navState!.notFoundUri = null;
        }else {
          // Update the list of pages by setting _selectedBook to null
          BooksListScreen.selectedBook.value = null;
        }

        return true;
      },
    );
  }

  @override
  RoutePath get currentConfiguration {
    if(TabbedNavScreen.navState!.notFoundUri != null) {
      return NotFoundRoutePath(uri: TabbedNavScreen.navState!.notFoundUri!);
    }

    if(TabbedNavScreen.navState!.selectedTabIndex == 1) {
      return SettingsPath();
    }

    return BooksListScreen.selectedBook.value == null
        ? BookListPath() : BookDetailPath(BooksListScreen.selectedBookId);
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) => path.configureState();
}

class RoutePath {

  final String resource;
  String get location => '/$resource/';
  final int navTabIndex;

  RoutePath(this.navTabIndex, this.resource);

  Future<void> configureState() {
    TabbedNavScreen.navState!.selectedTabIndex = navTabIndex;
    return Future.value();
  }

  RouteInformation? get routeInformation => RouteInformation(location: location);
}

class NotFoundRoutePath extends RoutePath {

  final Uri uri;

  NotFoundRoutePath({required this.uri}) : super(
      TabbedNavScreen.navState!.selectedTabIndex, '404-page-not-found');

  @override
  Future<void> configureState() {
    TabbedNavScreen.navState!.notFoundUri = uri;
    return Future.value();
  }
}

class DetailsRoutePath<T> extends RoutePath {

  final T id;

  DetailsRoutePath(int navTabIndex, this.id, String path) : super(navTabIndex, path);

  @override
  String get location => '${super.location}$id';
}

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  BookListPath() : super(BooksListScreen.navTabIndex, resourceName);

  static RoutePath? fromUri(Uri uri) =>
    uri.path == '/' || (uri.pathSegments.length == 1 && uri.pathSegments[0] == resourceName) ? BookListPath() : null;

  @override
  Future<void> configureState() {
    BooksListScreen.selectedBook.value = null;
    return super.configureState();
  }
}

class BookDetailPath extends DetailsRoutePath {

  static final String resourceName = BookListPath.resourceName;

  BookDetailPath(int bookId) : super(BookDetailsScreen.navTabIndex, bookId, resourceName);

  static RoutePath? fromUri(Uri uri) {
    if(uri.pathSegments.length == 2 && uri.pathSegments[0] == resourceName) {
      int? bookId = int.tryParse(uri.pathSegments[1]);
      if(bookId != null && BooksListScreen.isValidBookId(bookId)) {
          return BookDetailPath(bookId);
      }
    }
    return null;
  }

  @override
  Future<void> configureState() {
    BooksListScreen.selectedBook.value = BooksListScreen.books[id];
    return super.configureState();
  }
}

class SettingsPath extends RoutePath {
  static const String resourceName = 'settings';
  SettingsPath() : super(SettingsScreen.navTabIndex, resourceName);

  static RoutePath? fromUri(Uri uri) =>
    uri.pathSegments.length == 1 && uri.pathSegments[0] == resourceName ? SettingsPath() : null;
}

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

class BookDetailsScreen extends TabbedNavScreen {
  static const navTabIndex = 0;

  final Book book;

  BookDetailsScreen({
    required this.book,
  }) : super(
      pageTitle: book.title,
      tabIndex: navTabIndex
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

class SettingsScreen extends TabbedNavScreen {
  static const int navTabIndex = 1;

  SettingsScreen() : super(tabIndex: navTabIndex);

  @override
  Widget buildBody(BuildContext context) =>
    Center(
      child: Text('Settings screen'),
    );
}