import 'package:step_ai/features/chat/domain/entity/slash_prompt_list.dart';

abstract class SlashPromptRepository{
  Future<SlashPromptList?> getPromptList(String key);
}