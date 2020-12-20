import 'package:flutter/widgets.dart';

class CommonProvider extends ChangeNotifier {
  bool isSpinner = false;
  Future showSpinner(bool waitManually) async {
    isSpinner = !isSpinner;
    notifyListeners();
    if (waitManually) {
      await Future.delayed(Duration(milliseconds: 1000));
      isSpinner = false;
    }
    notifyListeners();
  }
}
