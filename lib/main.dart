import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/screens/404_nav_screen.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/src/routing/book_details_path.dart';
import 'package:startup_namer/src/routing/book_list_path.dart';
import 'package:startup_namer/src/routing/settings_path.dart';
import 'package:startup_namer/src/screens/book_details_screen.dart';
import 'package:startup_namer/src/screens/book_list_screen.dart';
import 'package:startup_namer/src/screens/settings_screen.dart';

import 'nav2/routing/nav_aware_route_info_parser.dart';
import 'nav2/routing/not_found_route_path.dart';
import 'nav2/routing/route_path.dart';

void main() {
  runApp(BooksApp());
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState(navState: TabNavState.instance);
}

class _BooksAppState extends State<BooksApp> {

  final TabNavState navState;

  BookRouterDelegate? _routerDelegate;
  NavAwareRouteInfoParser? _routeInformationParser;

  _BooksAppState({required this.navState}) {

    navState.tabs.addAll([
      TabInfo(id: 'Books', icon: Icons.home, title: 'Books'),
      TabInfo(id: 'Settings', icon: Icons.settings, title: 'Settings')
    ]);

    _routeInformationParser = NavAwareRouteInfoParser(
        navState: navState,
        routeParsers: [
          BookListPath.fromUri,
          BookDetailsPath.fromUri,
          SettingsPath.fromUri
        ]
    );

    _routerDelegate = BookRouterDelegate(navState: navState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books App',
      routerDelegate: _routerDelegate!,
      routeInformationParser: _routeInformationParser!,
    );
  }
}

class BookRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  final TabNavState navState;

  BookRouterDelegate({required this.navState}) : navigatorKey = GlobalKey<NavigatorState>()
  {
    BooksListScreen.selectedBook.addListener(notifyListeners);
    navState.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {

    return Navigator(
      key: navigatorKey,
      //transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        if(navState.selectedTabIndex == 1)
          SettingsScreen(navState: navState).page
        else
          ...[
            BooksListScreen(navState: navState).page,
            if (BooksListScreen.selectedBook.value != null)
              BookDetailsScreen(
                  navState: navState,
                  book: BooksListScreen.selectedBook.value!
              ).page
          ],
        if(navState.notFoundUri != null)
          UrlNotFoundScreen(navState: navState).page
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if(navState.notFoundUri != null) {
          navState.notFoundUri = null;
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
    if(navState.notFoundUri != null) {
      return NotFoundRoutePath(uri: navState.notFoundUri!, navState: navState);
    }

    return routeFromState;
  }

  RoutePath get routeFromState {
    if(navState.selectedTabIndex == 1) {
      return SettingsPath(navState: navState);
    }

    return BooksListScreen.selectedBook.value == null
        ? BookListPath(navState: navState) :
          BookDetailsPath(bookId: BooksListScreen.selectedBookId, navState: navState);
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) => path.configureState();
}
