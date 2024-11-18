import 'dart:convert';

import 'package:http/http.dart' as http;

class SignUpAPI {
  final String _baseUrl = 'https://api.dev.jarvis.cx';
  final _headers = {
    'x-jarvis-guid': '',
    'Content-Type': 'application/json'
  };
  final String _endPoint = '/api/v1/auth/sign-up';

  int _statusCode = 0;

  static final SignUpAPI _instance = SignUpAPI._internal();

  SignUpAPI._internal();

  factory SignUpAPI() {
    return _instance;
  }

  int get statusCode => _statusCode;

  Future<String> call(String email, String password, String username) async {
    var request = http.Request('POST', Uri.parse(_baseUrl + _endPoint));
    request.body = json.encode({
      "email": email,
      "password": password,
      "username": username,
    });

    request.headers.addAll(_headers);
    http.StreamedResponse response;
    try {
      response = await request.send();
      _statusCode = response.statusCode;
      print(_statusCode);

      if (response.statusCode == 201) {
        return response.stream.bytesToString();
      }
      else {
        return response.stream.transform(utf8.decoder).join();
      }
    } catch (e) {
      print('Exception: $e');
      return 'Error from Register API';
    }
  }
}