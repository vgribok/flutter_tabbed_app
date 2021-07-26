import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

class NotFoundRoutePath extends RoutePath {

  final Uri uri;

  NotFoundRoutePath({required this.uri}) : super(
      TabbedNavScreen.navState!.selectedTabIndex, '404-page-not-found');

  @override
  Future<void> configureState() {
    TabbedNavScreen.navState!.notFoundUri = uri;
    return Future.value();
  }
}
