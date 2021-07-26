import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

class RoutePath {

  final String resource;
  final int navTabIndex;
  final TabNavState navState;

  RoutePath({
    required this.navTabIndex,
    required this.resource,
    required this.navState
  });

  Future<void> configureState() {
    navState.selectedTabIndex = navTabIndex;
    return Future.value();
  }

  String get location => '/$resource/';

  RouteInformation? get routeInformation => RouteInformation(location: location);
}
