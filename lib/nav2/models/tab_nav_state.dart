import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_info.dart';
import 'package:startup_namer/nav2/screens/404_nav_screen.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

// TODO: Add back arrow support for tab switching
class TabNavState extends ChangeNotifier {

  final List<TabInfo> tabs = [];
  int _selectedTabIndex = 0;
  Uri? _notFoundUri;

  static final TabNavState instance = TabNavState();

  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int selectedTabIndex) {
    if(_selectedTabIndex == selectedTabIndex)
      return;

    if(selectedTabIndex < 0 || selectedTabIndex >= tabs.length) {
      print('Selected tab index $selectedTabIndex is outside the [0..${tabs.length-1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    }else
      _selectedTabIndex = selectedTabIndex;

    notifyListeners();
  }

  Uri? get notFoundUri => _notFoundUri;
  set notFoundUri(Uri? uri) {
    if(_notFoundUri != uri) {
      _notFoundUri = uri;
      notifyListeners();
    }
  }

  TabInfo get selectedTab => tabs[selectedTabIndex];

  Iterable<TabbedNavScreen> buildNavigatorScreenStack() sync* {
    yield* selectedTab.screenStack(this);

    if(notFoundUri != null) {
      yield UrlNotFoundScreen.notFoundScreenFactory(this);
    }
  }
}
