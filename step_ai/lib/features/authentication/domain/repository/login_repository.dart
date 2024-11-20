import 'package:step_ai/core/data/model/token_model.dart';

abstract class LoginRepository{
  Future<TokenModel?> login(String email, String password);
  Future<bool> get isLoggedIn;
  Future<void> saveLoginStatus(bool status);
}