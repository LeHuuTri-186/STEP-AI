import 'dart:convert';

import 'package:http/http.dart' as http;

class SignUpAPI {
  final String _baseUrl = 'https://api.jarvis.cx';
  final _headers = {
    'x-jarvis-guid': '',
    'Content-Type': 'application/json'
  };
  final String _endPoint = '/api/v1/auth/sign-up';


  static final SignUpAPI _instance = SignUpAPI._internal();

  SignUpAPI._internal();

  factory SignUpAPI() {
    return _instance;
  }

  Future<String> call(String email, String password, String username) async{
    var request = http.Request('POST', Uri.parse(_baseUrl + _endPoint));
    request.body = json.encode({
      "email": "Alexie9911@gmail.com",
      "password": "2wyML3agdX695ae",
      "username": "Terence",
    });

    request.headers.addAll(_headers);
    http.StreamedResponse response;
    try {
      response = await request.send();

      if (response.statusCode == 200) {
        print(response.statusCode);
        return response.stream.bytesToString();
      }
      else {
        return response.reasonPhrase!;
      }
    } catch (e){
      print('Exception: $e');
      return 'can';
    }
  }

}