import 'route_path.dart';

class BooksListPath extends RoutePath {
  @override
  String get location => '/home';

  @override
  String? get appBarTitle => null;

  @override
  int get selectedTabIndex => 0;
}
