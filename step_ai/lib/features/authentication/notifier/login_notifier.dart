import 'package:flutter/material.dart';
import 'package:step_ai/features/authentication/domain/param/login_param.dart';

import '../domain/usecase/login_usecase.dart';
import '../domain/usecase/save_token_usecase.dart';

class LoginNotifier extends ChangeNotifier{
  //Use cases:------------------------------------------------------------------
  final SaveTokenUseCase _saveTokenUseCase;
  final LoginUseCase _loginUseCase;

  //Others:---------------------------------------------------------------------
  bool _isLoading = false;
  String? _errorMessage;

  String? _emailError;
  String? _passwordError;

  //Methods:--------------------------------------------------------------------
  LoginNotifier(this._saveTokenUseCase, this._loginUseCase);

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  bool get isLoading => _isLoading;

  String? validateEmail(String email){
    if (email.isEmpty) {
      return "Email can not be empty";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return "Email type invalid";
    }
    return null;
  }

  String? validatePassword(String password){
    if (password.isEmpty) {
      return "Password can not be empty";
    }
    return null;
  }

  void setEmailError(String email){
    _emailError = validateEmail(email);
    notifyListeners();
  }

  void setPasswordError(String password){
    _passwordError = validatePassword(password);
    notifyListeners();
  }

  bool isInputValid(){
    return (_emailError == null && _passwordError == null);
  }

  void resetError(){
    _emailError = null;
    _passwordError = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _loginUseCase.call(
          params: LoginParam(email: email, password: password));
      return true;
    }
    catch (e){
      if (e == '422'){
        _emailError = 'Email or password invalid';
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}