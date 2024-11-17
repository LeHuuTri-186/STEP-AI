import 'package:flutter/material.dart';

class AuthenticateErrorNotifier extends ChangeNotifier{
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _usernameError;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmError => _confirmError;
  String? get usernameError => _usernameError;

  void setEmailError(String? value){
    _emailError = value;
    notifyListeners();
  }

  void setPasswordError(String? value){
    _passwordError = value;
    notifyListeners();
  }

  void setConfirmError(String? value){
    _confirmError = value;
    notifyListeners();
  }

  void setUsernameError(String? value){
    _usernameError = value;
    notifyListeners();
  }

  bool isValidLogin(){
    if (_emailError == null && _passwordError == null) return true;
    //true = ok
    return false;
  }

  bool isValidRegister(){
    if (_emailError == null && _passwordError == null &&
        _confirmError == null && _usernameError == null) return true; //ok
    return false;
  }

  void reset(){
    _emailError = null;
    _passwordError = null;
    _confirmError = null;
    _usernameError = null;
    notifyListeners();
  }

}