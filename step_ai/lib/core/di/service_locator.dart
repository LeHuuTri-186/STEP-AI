import 'package:step_ai/features/prompt/di/prompt_service_locator.dart';

Future<void> setupDependencyInjection() async {
  await initPromptService();
}