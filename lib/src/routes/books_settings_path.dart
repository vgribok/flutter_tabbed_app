import 'book_route_path.dart';

class BooksSettingsPath extends BookRoutePath {
  @override
  String get location => '/settings';

  @override
  String? get appBarTitle => 'Application Settings';

  @override
  int get selectedTabIndex => 1;
}
