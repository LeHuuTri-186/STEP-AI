import 'dart:async';
import 'dart:convert';

import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/model/token_model.dart';
import 'package:step_ai/core/usecases/use_case.dart';

class RefreshTokenUseCase extends UseCase<int, void>{
  final SecureStorageHelper _secureStorageHelper;
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);

  final headers = {
    'x-jarvis-guid': ''
  };
  RefreshTokenUseCase(this._secureStorageHelper);

  @override
  Future<int> call({required void params}) async{
    String? refreshToken = await _secureStorageHelper.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return 401;
    var response =
      await _apiService.get('${Constant.refreshTokenPartEndpoint}$refreshToken');

    if (response.statusCode == 200) {
      TokenModel token;
      token = TokenModel.fromJson(
          jsonDecode(await response.stream.bytesToString())
      );
      await _secureStorageHelper.saveAccessToken(token.accessToken);
      return 200;
    }
    return 401;
  }
}