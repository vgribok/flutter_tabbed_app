import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/src/screens/book_list_screen.dart';

class BookListPath extends RoutePath {
  static const String resourceName = 'books';

  BookListPath({required TabNavState navState}) :
        super(
          navState: navState,
          navTabIndex: BooksListScreen.navTabIndex,
          resource: resourceName);

  static RoutePath? fromUri(TabNavState navState, Uri uri) =>
      uri.path == '/' || (uri.pathSegments.length == 1 && uri.pathSegments[0] == resourceName) ?
        BookListPath(navState: navState) : null;

  @override
  Future<void> configureState() {
    BooksListScreen.selectedBook.value = null;
    return super.configureState();
  }
}
