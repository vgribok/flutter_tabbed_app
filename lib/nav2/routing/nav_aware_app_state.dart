import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_info.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';

import 'nav_aware_route_info_parser.dart';
import 'nav_aware_routing_delegate.dart';

// TODO: Document classes and add comments
class NavAwareAppState<T extends StatefulWidget> extends State<T> {

  final TabNavState navState;
  final String _appTitle;

  final NavAwareRouterDelegate _routerDelegate;
  final NavAwareRouteInfoParser _routeInformationParser;

  NavAwareAppState({
    required String appTitle,
    required this.navState,
    required List<RoutePathFactory> routeParsers,
    required List<TabInfo> tabs,
    List<ChangeNotifier>? stateItems
  }) :
    _appTitle = appTitle,
    _routeInformationParser = NavAwareRouteInfoParser(
        navState: navState,
        routeParsers: routeParsers
    ),
    _routerDelegate = NavAwareRouterDelegate(
        navState: navState,
        stateItems: stateItems
    )
  {
    navState.tabs.addAll(tabs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appTitle,
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }

  String get appTitle => _appTitle;
}