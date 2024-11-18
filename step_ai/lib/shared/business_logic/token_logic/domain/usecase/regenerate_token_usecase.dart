import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:step_ai/core/api/api_service.dart';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/shared/business_logic/token_logic/data/model/token_model.dart';
import 'package:step_ai/shared/business_logic/token_logic/domain/repository/auth_secure_storage_repository.dart';

import '../../../../../config/constants.dart';

class RegenerateTokenUseCase extends UseCase<int, void>{
  final AuthSecureStorageRepository _secureStorageRepository;
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  RegenerateTokenUseCase(this._secureStorageRepository);

  final headers = {
    'x-jarvis-guid': ''
  };

  @override
  FutureOr<int> call({required void params}) async{
    String? refreshToken = await _secureStorageRepository.getToken(
        Constant.refresh);

    if (refreshToken == null) return 401;
    var response = await _apiService.get(
      '${Constant.refreshTokenPartEndpoint}$refreshToken', headers: headers);

    if (response.statusCode == 200){
      TokenModel token = TokenModel.fromJson(jsonDecode(
          await response.stream.bytesToString()));
      _secureStorageRepository.saveToken(Constant.access, token.accessToken);
    }

    return response.statusCode;
  }

}