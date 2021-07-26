import 'package:flutter/material.dart';

class TabInfo {
  final String id;
  final IconData icon;
  final String? title;

  TabInfo ({required this.icon, this.title, required this.id});
}

class TabNavState extends ChangeNotifier {
  final List<TabInfo> tabs = [];
  int _selectedTabIndex = 0;
  Uri? _404Uri;

  static final TabNavState instance = TabNavState();

  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int selectedTabIndex) {
    if(_selectedTabIndex == selectedTabIndex)
      return;

    if(selectedTabIndex < 0 || selectedTabIndex >= tabs.length) {
      print('Selected tab index $selectedTabIndex is outside the [0..${tabs.length-1}] range. Setting index to 0.');
      _selectedTabIndex = 0;
    }else
      _selectedTabIndex = selectedTabIndex;

    notifyListeners();
  }

  Uri? get notFoundUri => _404Uri;
  set notFoundUri(Uri? uri) {
    _404Uri = uri;
    notifyListeners();
  }

  TabInfo get selectedTab => tabs[selectedTabIndex];
}
