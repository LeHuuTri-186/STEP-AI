
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/api/api_service.dart';
import 'package:step_ai/features/authentication/domain/repository/auth_secure_storage_repository.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';

class LogoutRepositoryImpl extends LogoutRepository{
  final AuthSecureStorageRepository _secureStorageRepository;
  final ApiService _apiService = ApiService(Constant.apiBaseUrl);
  LogoutRepositoryImpl(this._secureStorageRepository);

  @override
  Future<int> logout() async{
    var headers = await _executeHeadersBuild();
    var response = await _apiService.get(
      Constant.logoutEndpoint, headers: headers);
    return response.statusCode;
  }

  Future<Map<String, String>> _executeHeadersBuild() async{
    String? token = await _secureStorageRepository.getToken(Constant.access);
    var headers = {
      'x-jarvis-guid': '',
      'Authorization': 'Bearer $token}'
    };
    return headers;
  }

}