import 'package:flutter/material.dart';
import 'package:step_ai/features/authentication/domain/param/register_param.dart';
import 'package:step_ai/features/authentication/domain/repository/register_repository.dart';
import 'package:step_ai/features/authentication/domain/usecase/register_usecase.dart';

import '../domain/usecase/login_usecase.dart';
import '../../../shared/business_logic/token_logic/domain/usecase/save_token_usecase.dart';

class RegisterNotifier extends ChangeNotifier{
  //Use cases:------------------------------------------------------------------
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  //Others:---------------------------------------------------------------------
  bool _isLoading = false;
  String? _errorMessage;


  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _usernameError;


//Methods:--------------------------------------------------------------------
  RegisterNotifier(this._loginUseCase, this._registerUseCase, );

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmError => _confirmError;
  String? get usernameError => _usernameError;

  bool get isLoading => _isLoading;


  bool isInputValid(){
    return (_emailError == null && _passwordError == null &&
            _confirmError == null && _usernameError == null);
  }

  String? validateEmail(String email){
    if (email.isEmpty) {
      return "Email can not be empty";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return "Email invalid";
    }
    return null;
  }

  String? validatePassword(String password){
    if (password.isEmpty) {
      return "Password can not be empty";
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must include at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must include at least one lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must include at least one number.';
    }
    return null;
  }

  String? validateConfirmPw(String confirmPassword, String password){
    if (confirmPassword.isEmpty) {
      return "Confirm password can not be empty";
    }
    if (confirmPassword != password) {
      return "Confirm password mismatch ";
    }
    return null;
  }

  String? validateUsername(String username){
    if (username.isEmpty) {
      return "Username can not be empty";
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

  void setConfirmError(String confirm, String password){
    _confirmError = validateConfirmPw(confirm, password);
    notifyListeners();
  }

  void setUsernameError(String username){
    _usernameError = validateUsername(username);
    notifyListeners();
  }

  void resetError(){
    _emailError = null;
    _passwordError = null;
    _usernameError = null;
    _confirmError = null;
    notifyListeners();
  }

  //Register...
  Future<bool> register(
      String email, String password, String username) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      int returnStatus;
      returnStatus = await _registerUseCase.call(
          params: RegisterParam(
              email: email, password: password, username: username));
      if (returnStatus == 422){
        _emailError = 'Email already exists';
        return false;
      }
      if (returnStatus == 200) {
        return true;
      }
      return false;
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