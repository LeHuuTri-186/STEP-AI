import 'package:step_ai/features/chat/domain/entity/slash_prompt.dart';

class SlashPromptList{
  final List<SlashPrompt> prompts;

  SlashPromptList({required this.prompts});

  void setList(List<SlashPrompt> newList){
    prompts.clear();
    prompts.addAll(newList);
  }
}