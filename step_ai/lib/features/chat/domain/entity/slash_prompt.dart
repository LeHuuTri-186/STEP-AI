import 'package:step_ai/features/chat/data/model/search_prompt_model.dart';


class SlashPrompt {
  final String id;
  final String title;
  final String content;
  final String category;
  final String description;
  final bool isPublic;
  final String language;
  final String userId;
  final String userName;
  final bool isFavorite;

  SlashPrompt({required this.id, required this.description, required this.isPublic, required this.language, required this.userId, required this.userName, required this.isFavorite,
    required this.title, required this.content, required this.category});

  factory SlashPrompt.fromModel(SearchPromptModel model){
    return SlashPrompt(
        title: model.title, content: model.content, category: model.category, description: model.description, isPublic: model.isPublic, language: model.language, userId: model.userId, userName: model.userName, isFavorite: model.isFavorite, id: model.id);
  }
}

