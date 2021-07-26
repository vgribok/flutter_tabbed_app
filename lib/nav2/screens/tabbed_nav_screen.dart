
import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';

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

  ValueKey get key => ValueKey(tab.id);

  Page get page => MaterialPage(key: key, child: this);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: AppBar(title: Text(pageTitle)),
          body: buildBody(context),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              for(TabInfo tabInfo in navState.tabs)
                BottomNavigationBarItem(icon: Icon(tabInfo.icon), label: tabInfo.title)
            ],
            currentIndex: navState.selectedTabIndex,
            onTap: (newTabIndex) {
              navState.notFoundUri = null;
              navState.selectedTabIndex = newTabIndex;
            },
          )
      );

  Widget buildBody(BuildContext context);
}