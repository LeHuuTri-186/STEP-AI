import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:step_ai/config/constants.dart';

class LoginApi {
  final String _baseUrl = Constant.apiBaseUrl;
  final _headers = {
    'x-jarvis-guid': '',
    'Content-Type': 'application/json'
  };
  final String _endPoint = '/api/v1/auth/sign-in';

  int _statusCode = 0;

  static final LoginApi _instance = LoginApi._internal();

  LoginApi._internal();

  factory LoginApi() {
    return _instance;
  }

  int get statusCode => _statusCode;

  // Future<String> call(String email, String password) async{
  //   var request = http.Request('POST', Uri.parse(_baseUrl + _endPoint));
  //   request.body = json.encode({
  //     "email": email,
  //     "password": password,
  //   });
  //
  //   request.headers.addAll(_headers);
  //   http.StreamedResponse response;
  //   try {
  //     response = await request.send();
  //     _statusCode = response.statusCode;
  //
  //     if (response.statusCode == 200) {
  //       Map<String, String> tokens =
  //     }
  //     else {
  //       return response.stream.transform(utf8.decoder).join();
  //     }
  //   } catch (e){
  //     print('Exception: $e');
  //     return 'Error from Login API';
  //   }
  // }

  Future<Map<String, String>> extractToken(http.StreamedResponse res) async {
    final String responseBody = await res.stream.bytesToString();
    final Map<String, dynamic> jsonData = jsonDecode(responseBody);

    final String accessToken = jsonData['token']['accessToken'];
    final String refreshToken = jsonData['token']['refreshToken'];

    Map<String, String> tokens = {
      'access': accessToken,
      'refresh': refreshToken,
    };

    return tokens;
  }
}