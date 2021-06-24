import 'book_route_path.dart';

class BooksDetailsPath extends BookRoutePath {
  final int id;

  BooksDetailsPath(this.id);

  @override
  String get location => '/book/$id';

  @override
  String? get appBarTitle => 'Book Details';

  @override
  int get selectedTabIndex => 0;
}