import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/routing/route_path.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';
import 'package:startup_namer/src/routing/user_profile_path.dart';

class UserProfileScreen extends TabbedNavScreen {

  static const int navTabIndex = 1;

  UserProfileScreen({required TabNavState navState}) : super(
    pageTitle: 'User Profile',
    tabIndex: navTabIndex,
    navState: navState
  );

  @override
  Widget buildBody(BuildContext context)  =>
      Center(
        child: Text('User Profile will go here'),
      );

  @override
  RoutePath get routePath => UserProfilePath();
}