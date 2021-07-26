import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';

class NotFoundRoutePath extends RoutePath {

  final Uri uri;

  NotFoundRoutePath({required this.uri, required TabNavState navState}) :
    super(navTabIndex: navState.selectedTabIndex,
          navState: navState,
          resource: '404-page-not-found'
    );

  @override
  Future<void> configureState() {
    navState.notFoundUri = uri;
    return Future.value();
  }
}
