import 'package:step_ai/features/prompt/di/data_injection/prompt_data_di.dart';
import 'package:step_ai/features/prompt/di/presentation_injection/prompt_presentation_di.dart';

Future<void> initPromptService() async {
  await initPromptData();
  await initPromptPresentation();
}