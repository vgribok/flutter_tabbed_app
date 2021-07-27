import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_info.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/nav_aware_app_state.dart';
import 'package:startup_namer/src/routing/book_details_path.dart';
import 'package:startup_namer/src/routing/book_list_path.dart';
import 'package:startup_namer/src/routing/settings_path.dart';
import 'package:startup_namer/src/screens/book_list_screen.dart';
import 'package:startup_namer/src/screens/settings_screen.dart';

// TODO: Rename root package
void main() {
  runApp(BooksApp());
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends NavAwareAppState<BooksApp> {

  _BooksAppState() :
    super(
      appTitle: 'Books App',
      navState: TabNavState.instance,
      tabs: [
        // TODO: Add user/profile tab
        TabInfo(id: 'Books', icon: Icons.home, title: 'Books',
            rootScreenFactory: (nvState) => BooksListScreen(navState: nvState)),
        TabInfo(id: 'Settings', icon: Icons.settings, title: 'Settings',
            rootScreenFactory: (nvState) => SettingsScreen(navState: nvState))
      ],
      stateItems: [BooksListScreen.selectedBook],
      routeParsers: [
        BookListPath.fromUri,
        BookDetailsPath.fromUri,
        SettingsPath.fromUri
      ],
    );
}
