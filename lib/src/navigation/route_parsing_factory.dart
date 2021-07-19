import 'package:flutter/material.dart';
import 'package:startup_namer/src/routes/book_route_path.dart';
import 'package:startup_namer/src/routes/books_detail_path.dart';
import 'package:startup_namer/src/routes/books_list_path.dart';
import 'package:startup_namer/src/routes/books_settings_path.dart';

class RouteParsingFactory extends RouteInformationParser<BookRoutePath> {

  @override
  Future<BookRoutePath> parseRouteInformation(RouteInformation routeInformation)
  {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'settings') {
      return Future.value(BooksSettingsPath());
    } else {
      if (uri.pathSegments.length >= 2) {
        if (uri.pathSegments[0] == 'book') {
          return Future.value(BooksDetailsPath(int.tryParse(uri.pathSegments[1])!));
        }
      }
      return Future.value(BooksListPath());
    }
  }

  @override
  RouteInformation restoreRouteInformation(BookRoutePath configuration) {
    return RouteInformation(location: configuration.location);
  }
}
