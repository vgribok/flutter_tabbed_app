import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';
import 'package:startup_namer/src/routing/settings_path.dart';

class SettingsScreen extends TabbedNavScreen {
  static const int navTabIndex = 1;

  SettingsScreen({required TabNavState navState}) :
    super(tabIndex: navTabIndex, navState: navState);

  @override
  Widget buildBody(BuildContext context) =>
      Center(
        child: Text('Settings screen'),
      );

  @override
  RoutePath get routePath => SettingsPath();
}