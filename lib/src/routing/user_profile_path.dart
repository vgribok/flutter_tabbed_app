import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/nav2/utility/uri_extensions.dart';
import 'package:startup_namer/src/screens/user_profile_screen.dart';

class UserProfilePath extends RoutePath {

  static const String resourceName = 'profile';

  UserProfilePath() : super(
      navTabIndex: UserProfileScreen.navTabIndex,
      resource: resourceName
  );

  static RoutePath? fromUri(Uri uri) =>
      uri.isSingleSegmentPath(resourceName) ? UserProfilePath() : null;
}