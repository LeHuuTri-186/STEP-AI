import 'package:step_ai/features/email_composer/di/data_injection/email_composer_data_di.dart';
import 'package:step_ai/features/email_composer/di/domain_injection/email_composer_domain_di.dart';
import 'package:step_ai/features/email_composer/di/presentation_injection/email_composer_presentation_di.dart';

Future<void> initEmailComposerServices() async {
  await initEmailComposerData();
  await initEmailComposerDomain();
  await initEmailComposerPresentation();
}