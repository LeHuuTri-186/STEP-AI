import 'package:step_ai/features/chat/data/model/search_prompt_model.dart';


class SlashPrompt {
  final String title;
  final String content;
  final String category;

  SlashPrompt({
    required this.title, required this.content, required this.category});

  factory SlashPrompt.fromModel(SearchPromptModel model){
    return SlashPrompt(
        title: model.title, content: model.content, category: model.category);
  }
}

