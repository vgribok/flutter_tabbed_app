import 'package:startup_namer/nav2/routing/details_route_path.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/src/screens/book_details_screen.dart';
import 'package:startup_namer/src/screens/book_list_screen.dart';

import 'book_list_path.dart';

class BookDetailsPath extends DetailsRoutePath {

  static final String resourceName = BookListPath.resourceName; // 'books'

  BookDetailsPath(int bookId) : super(BookDetailsScreen.navTabIndex, bookId, resourceName);

  static RoutePath? fromUri(Uri uri) {
    if(uri.pathSegments.length == 2 && uri.pathSegments[0] == resourceName) {
      int? bookId = int.tryParse(uri.pathSegments[1]);
      if(bookId != null && BooksListScreen.isValidBookId(bookId)) {
        return BookDetailsPath(bookId);
      }
    }
    return null;
  }

  @override
  Future<void> configureState() {
    BooksListScreen.selectedBook.value = BooksListScreen.books[id];
    return super.configureState();
  }
}