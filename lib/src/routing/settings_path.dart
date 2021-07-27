import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/nav2/utility/uri_extensions.dart';
import 'package:startup_namer/src/screens/settings_screen.dart';

class SettingsPath extends RoutePath {

  static const String resourceName = 'settings';

  SettingsPath() :
    super(
      navTabIndex: SettingsScreen.navTabIndex,
      resource: resourceName
    );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? SettingsPath() : null;
}
