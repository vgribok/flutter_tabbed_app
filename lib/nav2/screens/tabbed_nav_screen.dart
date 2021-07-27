import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_info.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';

typedef BodyBuilder = Widget Function(BuildContext);

abstract class TabbedNavScreen extends StatelessWidget {

  final String? _pageTitle;
  final int _tabIndex;
  final TabNavState navState;

  TabbedNavScreen(
      {
        String? pageTitle,
        required int tabIndex,
        required this.navState
      }) :
        this._pageTitle = pageTitle,
        this._tabIndex = tabIndex;

  int get tabIndex => _tabIndex;

  TabInfo get tab => navState.tabs[tabIndex];

  String get pageTitle => _pageTitle ?? tab.title ?? tab.id;

  ValueKey get key => ValueKey(routePath.location);

  Page get page => MaterialPage(key: key, child: this);

  RoutePath get routePath;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: buildAppBar(context, pageTitle),
          body: buildBody(context),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              for(TabInfo tabInfo in navState.tabs)
                buildTabItem(context, tabInfo)
            ],
            currentIndex: navState.selectedTabIndex,
            onTap: (newTabIndex) {
              navState.notFoundUri = null;
              navState.selectedTabIndex = newTabIndex;
            },
          )
      );

  Widget buildBody(BuildContext context);

  TabbedNavScreen? get topScreen => null;

  void removeFromNavStackTop() {}

  // TODO: replace with factory
  BottomNavigationBarItem buildTabItem(BuildContext context, TabInfo tabInfo) =>
      BottomNavigationBarItem(icon: Icon(tabInfo.icon), label: tabInfo.title);

  // TODO: replace with factory
  AppBar buildAppBar(BuildContext context, String pageTitle) =>
      AppBar(title: Text(pageTitle));
}