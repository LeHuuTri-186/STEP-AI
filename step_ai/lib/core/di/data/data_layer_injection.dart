import 'package:step_ai/core/di/data/module/local_module.dart';

import 'module/repository_module.dart';

class DataLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await LocalModule.configureLocalModuleInjection();
    await RepositoryModule.configureRepositoryModuleInjection();
  }
}