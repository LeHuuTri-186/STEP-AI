import 'package:get_it/get_it.dart';
import 'package:step_ai/features/email_composer/di/email_composer_service_locator.dart';

import 'data/data_layer_injection.dart';
import 'domain/domain_layer_injection.dart';
import 'presentation/presentation_layer_injection.dart';
import 'package:step_ai/features/prompt/di/prompt_service_locator.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> configureDependencies() async {
    await DataLayerInjection.configureDataLayerInjection();
    await DomainLayerInjection.configureDomainLayerInjection();
    await PresentationLayerInjection.configurePresentationLayerInjection();
    await initPromptService();
    await initEmailComposerServices();
  }
}