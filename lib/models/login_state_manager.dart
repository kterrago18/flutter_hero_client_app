import 'package:flutter/cupertino.dart';

class LoginStateManager extends ChangeNotifier {
  bool get didCreateAccountSelected => _didCreateAccountSelected;
  bool get didForgotPasswordSelected => _didForgotPasswordSelected;

  var _didCreateAccountSelected = false;
  var _didForgotPasswordSelected = false;

  void tapOnCreateAccount(bool selected) {
    _didCreateAccountSelected = selected;
    notifyListeners();
  }

  void tapOnForgotPassword(bool selected) {
    _didForgotPasswordSelected = selected;
    notifyListeners();
  }
}
