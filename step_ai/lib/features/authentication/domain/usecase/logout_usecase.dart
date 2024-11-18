import 'dart:async';

import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/authentication/domain/repository/logout_repository.dart';


class LogoutUseCase extends UseCase<void, void>{
  final LogoutRepository _logoutRepository;
  final SharedPreferencesHelper _sharedPreferencesHelper;
  final SecureStorageHelper _secureStorageHelper;

  LogoutUseCase(
      this._logoutRepository,
      this._sharedPreferencesHelper,
      this._secureStorageHelper);

  @override
  FutureOr<void> call({required void params}) async{
    int statusCode = await _logoutRepository.logout();
    if (statusCode == 401){
      await _secureStorageHelper.deleteAll();
      await _sharedPreferencesHelper.saveIsLoggedIn(false);
      return;
    }
    throw ('Error at logout use case');
  }
}