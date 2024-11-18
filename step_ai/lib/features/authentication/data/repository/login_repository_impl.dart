import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/core/data/model/token_model.dart';
import 'package:step_ai/features/authentication/domain/repository/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository{
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  final SharedPreferencesHelper _sharedPreferencesHelper;

  LoginRepositoryImpl(this._sharedPreferencesHelper);

  final _headers = {
    'x-jarvis-guid': '',
    'Content-Type': 'application/json'
  };

  @override
  Future<TokenModel?> login(String email, String password) async{
    try {
      var body = {
        "email": email,
        "password": password,
      };

      var response = await _apiService.post(
        Constant.loginEndpoint,
        body: body,
        headers: _headers);

      print('Login ${response.statusCode}');
      //200 for login success
      if (response.statusCode == 200){
        TokenModel token;

        token = TokenModel.fromJson(await _processResponse(response));
        return token;
      }
      else if (response.statusCode == 422){
        return null;
      }
      else {
        throw ('Error: ${response.reasonPhrase!}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Xử lý Response
  Future<Map<String, dynamic>> _processResponse(
      http.StreamedResponse response) async{
    return jsonDecode(await response.stream.bytesToString());
  }

  @override
  Future<bool> get isLoggedIn => _sharedPreferencesHelper.isLoggedIn;

  @override
  Future<void> saveLoginStatus(bool status) =>
      _sharedPreferencesHelper.saveIsLoggedIn(status);
}