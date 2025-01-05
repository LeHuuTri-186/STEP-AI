import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';


import '../../../../shared/usecases/refresh_token_usecase.dart';
import '../../../playground/data/models/kb_token_model.dart';

class LoginKbUseCase extends UseCase<int, void>{
  final SecureStorageHelper _secureStorageHelper;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final ApiService _rest = ApiService(Constant.kbApiUrl);

  LoginKbUseCase(this._secureStorageHelper, this._refreshTokenUseCase);

  /// Xử lý Response
  Future<Map<String, dynamic>> _processResponse(
      http.StreamedResponse response) async{
    return jsonDecode(await response.stream.bytesToString());
  }

  @override
  Future<int> call({required void params}) async{
    String? accessToken = await _secureStorageHelper.accessToken;

    if (accessToken == null) {
      int code = await _refreshTokenUseCase.call(params: null);
      if (code == 200) {
        return call(params: null);
      }
      else {
        print("refresh token expired");
        return 401;
      }
    }

    var headers = {
      'x-jarvis-guid': '',
      'Content-Type': 'application/json'
    };
    var body = {
      "token": accessToken,
    };

    var response = await _rest.post(
        Constant.loginKbEndpoint,
        body: body,
        headers: headers);

    print(response.statusCode);
    if (response.statusCode == 200) {
      KbTokenModel tokens = KbTokenModel.fromJson(
          await _processResponse(response));
      print("Access: ${tokens.kbAccessToken}");
      await _secureStorageHelper.saveKbTokens(tokens);
      return 200;
    }

    if (response.statusCode == 401) {
      int code = await _refreshTokenUseCase.call(params: null);
      if (code == 200) {
        return call(params: null);
      }
      else {
        return 401;
      }
    }
    return -1;
  }
}