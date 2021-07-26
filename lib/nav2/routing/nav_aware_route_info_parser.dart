import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/routing/not_found_route_path.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';

typedef RoutePathFactory = RoutePath? Function(Uri);

class NavAwareRouteInfoParser extends RouteInformationParser<RoutePath> {

  final List<RoutePathFactory> routeParsers;

  NavAwareRouteInfoParser({required this.routeParsers});

  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location!);

    for (RoutePathFactory routePathFactory in routeParsers) {
      RoutePath? path = routePathFactory(uri);
      if (path != null)
        return Future.value(path);
    }

    return Future.value(NotFoundRoutePath(uri: uri));
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath path) => path.routeInformation;
}