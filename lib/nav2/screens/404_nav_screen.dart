import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/models/tab_nav_state.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

class UrlNotFoundScreen extends TabbedNavScreen {

  static String defaultMessage = 'Following URI is incorrect: ';
  static String defaultTitle = 'Resource not found';

  UrlNotFoundScreen({required TabNavState navState}) :
    super(
      pageTitle: defaultTitle,
      tabIndex: navState.selectedTabIndex,
      navState: navState
    );

  @override
  ValueKey get key => ValueKey('404-not-found-page');

  @override
  Widget buildBody(BuildContext context) =>
    Center(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(defaultMessage),
          Text(
              '\"${navState.notFoundUri}\"',
              style: TextStyle(fontWeight: FontWeight.bold)
          )
        ])
    );
}