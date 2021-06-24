import 'book_route_path.dart';

class BooksListPath extends BookRoutePath {
  @override
  String get location => '/home';

  @override
  String? get appBarTitle => null;

  @override
  int get selectedTabIndex => 0;
}
