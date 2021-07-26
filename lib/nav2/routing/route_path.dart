import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

class RoutePath {

  final String resource;
  String get location => '/$resource/';
  final int navTabIndex;

  RoutePath(this.navTabIndex, this.resource);

  Future<void> configureState() {
    TabbedNavScreen.navState!.selectedTabIndex = navTabIndex;
    return Future.value();
  }

  RouteInformation? get routeInformation => RouteInformation(location: location);
}
