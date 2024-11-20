

import 'package:step_ai/core/di/presentation/module/provider_module.dart';

class PresentationLayerInjection {
  static Future<void> configurePresentationLayerInjection() async {
    await ProviderModule.configureStoreModuleInjection();
  }
}