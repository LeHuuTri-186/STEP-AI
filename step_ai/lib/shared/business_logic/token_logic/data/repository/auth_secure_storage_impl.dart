import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:step_ai/shared/business_logic/token_logic/domain/repository/auth_secure_storage_repository.dart';

class AuthSecureStorageImpl extends AuthSecureStorageRepository{
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> deleteToken(String key) async{
    await _secureStorage.delete(key: key);
  }

  @override
  Future<String?> getToken(String key) async{
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> saveToken(String key, String token) async{
    await _secureStorage.write(key: key, value: token);
  }

}