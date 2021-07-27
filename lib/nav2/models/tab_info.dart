import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

typedef TabRootScreenFactory = TabbedNavScreen Function(TabNavState navState);

class TabInfo {
  final String id;
  final IconData icon;
  final String? title;
  final TabRootScreenFactory rootScreenFactory;

  TabInfo ({
    required this.icon,
    this.title,
    required this.id,
    required this.rootScreenFactory
  });

  Iterable<TabbedNavScreen> screenStack(TabNavState navState) sync* {
    final TabbedNavScreen rootScreen = rootScreenFactory(navState);
    yield rootScreen;

    for(TabbedNavScreen? nextScreen = rootScreen.topScreen ; nextScreen != null ; nextScreen = nextScreen.topScreen)
      yield nextScreen;
  }
}