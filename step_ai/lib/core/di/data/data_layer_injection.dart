import 'module/repository_module.dart';

class DataLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await RepositoryModule.configureRepositoryModuleInjection();
  }
}