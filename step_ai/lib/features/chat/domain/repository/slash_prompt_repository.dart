import 'package:step_ai/features/chat/domain/entity/slash_prompt_list.dart';

import '../entity/slash_prompt.dart';

abstract class SlashPromptRepository{
  Future<SlashPromptList?> getPromptList(String key);
  Future<List<SlashPrompt>?> getFeaturedPrompt({int offset});
}