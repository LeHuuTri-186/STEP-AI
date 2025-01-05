import 'dart:convert';

import 'assistant.dart';

class ComposeEmail {
  final String action;
  final Assistant? assistant;
  final String? language;
  final String type;
  final String? content;

  ComposeEmail({
    required this.action,
    this.assistant,
    this.content,
    this.language,
    required this.type,
  });

  factory ComposeEmail.fromModel(Map<String, dynamic> json) => ComposeEmail(
      action: json["action"],
      assistant: json["assistant"] == null
          ? null
          : Assistant.fromJson(json["assistant"]),
      language: json["metadata"]['translateTo'],
      type: json['type'],
      content: json['content']
  );
}
