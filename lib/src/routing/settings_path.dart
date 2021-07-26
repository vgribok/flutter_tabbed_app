import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/src/screens/settings_screen.dart';

class SettingsPath extends RoutePath {

  static const String resourceName = 'settings';

  SettingsPath({required TabNavState navState}) :
    super(
      navTabIndex: SettingsScreen.navTabIndex,
      navState: navState,
      resource: resourceName
    );

  static RoutePath? fromUri(TabNavState navState, Uri uri) =>
      uri.pathSegments.length == 1 && uri.pathSegments[0] == resourceName ?
        SettingsPath(navState: navState) : null;
}
