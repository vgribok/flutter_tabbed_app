import 'package:flutter/cupertino.dart';

class BetterChangeNotifier extends ChangeNotifier {
  void update(Function setter) {
    setter();
    notifyListeners();
  }
}