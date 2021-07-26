import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

class SettingsScreen extends TabbedNavScreen {
  static const int navTabIndex = 1;

  SettingsScreen() : super(tabIndex: navTabIndex);

  @override
  Widget buildBody(BuildContext context) =>
      Center(
        child: Text('Settings screen'),
      );
}