import 'package:flutter/material.dart';

class AuthenticateUINotifier extends ChangeNotifier{
  bool _isLogin = true;
  bool _isPasswordShowing = false;
  bool _isConfirmPwShowing = false;

  bool get isLogin => _isLogin;
  bool get isPasswordShowing => _isPasswordShowing;
  bool get isConfirmPwShowing => _isConfirmPwShowing;

  void setToLogin(){
    _isLogin = true;
    notifyListeners();
  }

  void setToRegister(){
    _isLogin = false;
    notifyListeners();
  }

  void setToSpecific(bool value){
    _isLogin = value;
    notifyListeners();
  }

  void toggleLogin(){
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void toggleShowPassword(){
    _isPasswordShowing = !_isPasswordShowing;
    notifyListeners();
  }

  void toggleShowConfirmPassword(){
    _isConfirmPwShowing = !_isConfirmPwShowing;
    notifyListeners();
  }

}