import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:step_ai/features/chat/domain/entity/slash_prompt.dart';

part 'prompt_model.freezed.dart';
part 'prompt_model.g.dart';

@freezed
class PromptModel with _$PromptModel {
  const factory PromptModel({
    @JsonKey(name: "_id") @Default('') String id,
    @JsonKey(name: "category") required String category,
    @JsonKey(name: "content") required String content,
    @JsonKey(name: "createdAt") @Default('') String createdAt,
    @JsonKey(name: "description") @Default('') String description,
    @JsonKey(name: "isFavorite") required bool isFavorite,
    @JsonKey(name: "isPublic") required bool isPublic,
    @JsonKey(name: "language") @Default('') String? language,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "updatedAt") @Default('') String? updatedAt,
    @JsonKey(name: "userId") String? userId,
    @JsonKey(name: "userName") required String userName,
  }) = _PromptModel;

  factory PromptModel.fromJson(Map<String, dynamic> json) =>
      _$PromptModelFromJson(json);

  factory PromptModel.fromSlash(SlashPrompt prompt) => PromptModel(
        id: prompt.id,
        category: prompt.category,
        content: prompt.content,
        isFavorite: prompt.isFavorite,
        isPublic: prompt.isPublic,
        title: prompt.title,
        userName: prompt.userName,
      );
}
