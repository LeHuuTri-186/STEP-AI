import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/usecase/login_kb_usecase.dart';
import 'package:step_ai/features/personal/data/models/kb_token_model.dart';

import 'refresh_token_usecase.dart';

class RefreshKbTokenUseCase extends UseCase<int, void>{
  final SecureStorageHelper _secureStorageHelper;

  final ApiService _apiService = ApiService(Constant.kbApiUrl);

  final RefreshTokenUseCase _refreshTokenUseCase;
  final LoginKbUseCase _loginKbUseCase;

  final headers = {
    'x-jarvis-guid': ''
  };
  RefreshKbTokenUseCase(
      this._secureStorageHelper,
      this._refreshTokenUseCase,
      this._loginKbUseCase
      );

  @override
  Future<int> call({required void params}) async{
    String? kbRefreshToken = await _secureStorageHelper.kbRefreshToken;

    if (kbRefreshToken == null || kbRefreshToken.isEmpty){
      int code = await _refreshTokenUseCase.call(params: null);
      if (code == 200) {
        await _loginKbUseCase.call(params: null); //can't be 401
      }
      else {
        throw 401;
      }
    }
    var response =
    await _apiService.get('${Constant.kbRefreshEndpointPart}$kbRefreshToken');

    if (response.statusCode == 200) {
      KbTokenModel token;
      token = KbTokenModel.fromJson(
          jsonDecode(await response.stream.bytesToString())
      );
      await _secureStorageHelper.saveKbTokens(token);
      return 200;
    }
    else {
      int code = await _refreshTokenUseCase.call(params: null);
      if (code == 200) {
        await _loginKbUseCase.call(params: null); //can't be 401
      }
      else {
        throw 401;
      }
    }
    throw 401;
  }
}