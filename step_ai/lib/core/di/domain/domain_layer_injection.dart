import 'package:step_ai/core/di/domain/module/usecase_module.dart';


class DomainLayerInjection {
  static Future<void> configureDomainLayerInjection() async {
    await UseCaseModule.configureUseCaseModuleInjection() ;
  }
}