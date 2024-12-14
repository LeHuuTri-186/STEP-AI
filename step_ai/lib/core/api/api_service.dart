import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService{
  final String baseUrl;

  ApiService(this.baseUrl);
  ///GET:
  Future<http.StreamedResponse> get(
      String endpoint, {Map<String, String>? headers}) async {
    var request = http.Request('GET', Uri.parse('$baseUrl$endpoint'));
    if (headers !=null) {
      request.headers.addAll(headers);
    }
    final http.StreamedResponse response = await request.send();
    return response;
  }

  ///POST
  Future<http.StreamedResponse> post(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {

    var request = http.Request('POST', Uri.parse('$baseUrl$endpoint'));
    if (headers != null){
      request.headers.addAll(headers);
    }
    request.body = jsonEncode(body);
    final http.StreamedResponse response = await request.send();
    return response;
  }

  ///PUT
  Future<http.StreamedResponse> put(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {

    var request = http.Request('PUT', Uri.parse('$baseUrl$endpoint'));
    if (headers != null){
      request.headers.addAll(headers);
    }
    request.body = jsonEncode(body);
    final http.StreamedResponse response = await request.send();
    return response;
  }

  ///DELETE
  Future<http.StreamedResponse> delete(String endpoint, {Map<String, String>? headers}) async {
    var request = http.Request('DELETE', Uri.parse('$baseUrl$endpoint'));
    if (headers !=null) {
      request.headers.addAll(headers);
    }
    final http.StreamedResponse response = await request.send();
    return response;
  }

  ///PATCH
  Future<http.StreamedResponse> patch(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {

    var request = http.Request('PATCH', Uri.parse('$baseUrl$endpoint'));
    if (headers != null) {
      request.headers.addAll(headers);
    }
    request.body = jsonEncode(body);
    final http.StreamedResponse response = await request.send();
    return response;
  }

  /// Xử lý Response
  Future<Map<String, dynamic>> _processResponse(
      http.StreamedResponse response) async{
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw Exception(
          'Error: ${response.statusCode}, ${response.reasonPhrase!}');
    }
  }
}