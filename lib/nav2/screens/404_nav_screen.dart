import 'package:flutter/material.dart';
import 'package:startup_namer/nav2/screens/tabbed_nav_screen.dart';

class UrlNotFoundScreen extends TabbedNavScreen {

  static String defaultMessage = 'Following URI is incorrect: ';
  static String defaultTitle = 'Resource not found';

  UrlNotFoundScreen() :
    super(
      pageTitle: defaultTitle,
      tabIndex: TabbedNavScreen.navState?.selectedTabIndex ?? 0,
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
              '\"${TabbedNavScreen.navState!.notFoundUri}\"',
              style: TextStyle(fontWeight: FontWeight.bold)
          )
        ])
    );
}