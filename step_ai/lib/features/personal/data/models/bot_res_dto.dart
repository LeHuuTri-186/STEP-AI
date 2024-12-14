import 'package:step_ai/features/personal/data/models/bot_model.dart';

///AssistantResDto
class BotResDto{
  String assistantName;
  DateTime createdAt;
  String? createdBy;
  String? description;
  String id;
  String? instructions;
  String openAiAssistantId;
  String? openAiThreadIdPlay;
  DateTime? updatedAt;
  String? updatedBy;

  BotResDto({
    required this.assistantName,
    required this.createdAt,
    this.createdBy,
    this.description,
    required this.id,
    this.instructions,
    required this.openAiAssistantId,
    this.openAiThreadIdPlay,
    this.updatedAt,
    this.updatedBy,
  });

  factory BotResDto.fromJson(Map<String, dynamic> json) {
    return BotResDto(
      assistantName: json['assistantName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      description: json['description'] as String?,
      id: json['id'] as String,
      instructions: json['instructions'] as String?,
      openAiAssistantId: json['openAiAssistantId'] as String,
      openAiThreadIdPlay: json['openAiThreadIdPlay'] as String?,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      updatedBy: json['updatedBy'] as String?,
    );
  }

  BotResDto copyWith({
    String? assistantName,
    DateTime? createdAt,
    String? createdBy,
    String? description,
    String? id,
    String? instructions,
    String? openAiAssistantId,
    String? openAiThreadIdPlay,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return BotResDto(
      assistantName: assistantName ?? this.assistantName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      id: id ?? this.id,
      instructions: instructions ?? this.instructions,
      openAiAssistantId: openAiAssistantId ?? this.openAiAssistantId,
      openAiThreadIdPlay: openAiThreadIdPlay ?? this.openAiThreadIdPlay,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}