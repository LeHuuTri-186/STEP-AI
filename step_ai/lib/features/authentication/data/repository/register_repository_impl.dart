import 'dart:convert';

import 'package:step_ai/features/authentication/domain/repository/register_repository.dart';

import '../../../../config/constants.dart';
import '../../../../core/api/api_service.dart';

class RegisterRepositoryImpl extends RegisterRepository{
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  final _headers = {
    'x-jarvis-guid': '',
    'Content-Type': 'application/json'
  };

  @override
  Future<int> register(String email, String password, String username) async{
    var body = {
      "email": email,
      "password": password,
      "username": username,
    };
    var response = await _apiService.post(
        Constant.registerEndpoint,
        body: body,
        headers: _headers);
    return response.statusCode;
  }
}