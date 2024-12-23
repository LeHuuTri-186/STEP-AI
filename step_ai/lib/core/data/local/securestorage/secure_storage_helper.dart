import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:step_ai/config/constants.dart';
import 'package:step_ai/core/data/local/securestorage/constants/storage.dart';
import 'package:step_ai/features/personal/data/models/kb_token_model.dart';

class SecureStorageHelper{
  final FlutterSecureStorage _secureStorage;

  //Constructor
  SecureStorageHelper(this._secureStorage);

  //General Methods:------------------------------------------------------------
  Future<String?> get accessToken async{
    return await _secureStorage.read(key: Storage.accessToken);
  }

  Future<String?> get refreshToken async{
    return await _secureStorage.read(key: Storage.refreshToken);
  }

  Future<String?> get kbAccessToken async{
    return await _secureStorage.read(key: Storage.kbAccessToken);
  }

  Future<String?> get kbRefreshToken async{
    return await _secureStorage.read(key: Storage.kbRefreshToken);
  }

  //----------------------------------------------------------------------------

  Future<void> saveAccessToken(String token) async{
    await _secureStorage.write(key: Storage.accessToken, value: token);
  }

  Future<void> saveRefreshToken(String token) async{
    await _secureStorage.write(key: Storage.refreshToken, value: token);
  }

  Future<void> saveKbTokens(KbTokenModel tokens) async{
    await _secureStorage.write(key: Storage.kbAccessToken, value: tokens.kbAccessToken);
    await _secureStorage.write(key: Storage.kbRefreshToken, value: tokens.kbRefreshToken);
  }

  //Delete:---------------------------------------------------------------------
  Future<void> deleteToken(String key) async{
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async{
    await _secureStorage.deleteAll();
  }

  //Theme:----------------------------------------------------------------------
}