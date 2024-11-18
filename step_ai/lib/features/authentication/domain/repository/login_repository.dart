import 'package:step_ai/shared/business_logic/token_logic/data/model/token_model.dart';

abstract class LoginRepository{
  Future<TokenModel?> login(String email, String password);
}