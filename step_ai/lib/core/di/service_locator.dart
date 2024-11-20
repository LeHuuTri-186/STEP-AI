import 'package:get_it/get_it.dart';

import 'data/data_layer_injection.dart';
import 'domain/domain_layer_injection.dart';
import 'presentation/presentation_layer_injection.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> configureDependencies() async {
    await DataLayerInjection.configureDataLayerInjection();
    await DomainLayerInjection.configureDomainLayerInjection();
    await PresentationLayerInjection.configurePresentationLayerInjection();
  }
}import 'package:step_ai/features/prompt/di/prompt_service_locator.dart';

Future<void> setupDependencyInjection() async {
  await initPromptService();
}