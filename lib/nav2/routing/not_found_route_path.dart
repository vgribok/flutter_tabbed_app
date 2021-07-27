import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';

class NotFoundRoutePath extends RoutePath {

  final Uri notFoundUri;

  NotFoundRoutePath({required this.notFoundUri, required int navTabIndex}) :
    super(navTabIndex: navTabIndex, resource: '404-page-not-found');

  @override
  Future<void> configureState(TabNavState navState, List<ChangeNotifier> stateItems) {
    navState.notFoundUri = notFoundUri;
    return Future.value();
  }
}
