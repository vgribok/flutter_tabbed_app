import 'package:startup_namer/nav2/routing/route_path.dart';

class DetailsRoutePath<T> extends RoutePath {

  final T id;

  DetailsRoutePath(int navTabIndex, this.id, String path) : super(navTabIndex, path);

  @override
  String get location => '${super.location}$id';
}
