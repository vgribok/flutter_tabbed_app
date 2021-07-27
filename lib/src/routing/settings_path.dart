import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/src/screens/settings_screen.dart';

class SettingsPath extends RoutePath {

  static const String resourceName = 'settings';

  SettingsPath() :
    super(
      navTabIndex: SettingsScreen.navTabIndex,
      resource: resourceName
    );

  static RoutePath? fromUri(Uri uri) =>
      uri.pathSegments.length == 1 && uri.pathSegments[0] == resourceName ?
        SettingsPath() : null;
}
