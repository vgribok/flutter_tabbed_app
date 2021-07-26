import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/screens/404_nav_screen.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';
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
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  BookRouterDelegate _routerDelegate = BookRouterDelegate();
  NavAwareRouteInfoParser _routeInformationParser =  NavAwareRouteInfoParser(
    routeParsers: [
      BookListPath.fromUri,
      BookDetailsPath.fromUri,
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
        ? BookListPath() : BookDetailsPath(BooksListScreen.selectedBookId);
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) => path.configureState();
}
