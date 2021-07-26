import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/src/screens/book_list_screen.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  BookListPath() : super(BooksListScreen.navTabIndex, resourceName);

  static RoutePath? fromUri(Uri uri) =>
      uri.path == '/' || (uri.pathSegments.length == 1 && uri.pathSegments[0] == resourceName) ? BookListPath() : null;

  @override
  Future<void> configureState() {
    BooksListScreen.selectedBook.value = null;
    return super.configureState();
  }
}
