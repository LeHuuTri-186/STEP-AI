import 'package:step_ai/features/authentication/data/models/token_model.dart';

abstract class LoginRepository{
  Future<TokenModel?> login(String email, String password);
}