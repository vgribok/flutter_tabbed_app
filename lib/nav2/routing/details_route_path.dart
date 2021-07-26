import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';

class DetailsRoutePath<T> extends RoutePath {

  final T id;

  DetailsRoutePath({
    required TabNavState navState,
    required int navTabIndex,
    required this.id,
    required String resource
  }) : super(
      navState: navState,
      navTabIndex: navTabIndex,
      resource: resource
  );

  @override
  String get location => '${super.location}$id';
}
