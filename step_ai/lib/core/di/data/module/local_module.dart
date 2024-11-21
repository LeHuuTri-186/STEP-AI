import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_ai/core/data/local/securestorage/secure_storage_helper.dart';
import 'package:step_ai/core/data/local/sharedpref/shared_preferences_helper.dart';
import 'package:step_ai/core/di/service_locator.dart';

class LocalModule {
  static Future<void> configureLocalModuleInjection() async {
    //Shared Preferences:-------------------------------------------------------
    getIt.registerSingletonAsync<SharedPreferences>(
        SharedPreferences.getInstance);

    getIt.registerSingleton<SharedPreferencesHelper>(
      SharedPreferencesHelper(await getIt.getAsync<SharedPreferences>())
    );
    //Secure Storage:-----------------------------------------------------------
    getIt.registerSingletonAsync<FlutterSecureStorage>(
        () async => const FlutterSecureStorage(),
    );
    getIt.registerSingleton<SecureStorageHelper>(SecureStorageHelper(
      await getIt.getAsync<FlutterSecureStorage>())
    );
  }
}