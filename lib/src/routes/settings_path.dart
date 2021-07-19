import 'route_path.dart';

class SettingsPath extends RoutePath {
  @override
  String get location => '/settings';

  @override
  String? get appBarTitle => 'Application Settings';

  @override
  int get selectedTabIndex => 1;
}
