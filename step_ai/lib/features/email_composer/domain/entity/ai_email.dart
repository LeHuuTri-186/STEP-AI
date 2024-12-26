import 'dart:convert';

import 'assistant.dart';
import 'email_style.dart';

class AiEmail {
  final String action;
  final Assistant? assistant;
  final String email;
  final String mainIdea;
  final String language;
  final String? receiver;
  final String? sender;
  final EmailStyle style;
  final String? subject;

  AiEmail({
    required this.action,
    this.assistant,
    required this.email,
    required this.mainIdea,
    this.sender,
    this.receiver,
    this.subject,
    required this.language,
    required this.style,
  });

  factory AiEmail.fromModel(Map<String, dynamic> json) => AiEmail(
        action: json["action"],
        assistant: json["assistant"] == null
            ? null
            : Assistant.fromJson(json["assistant"]),
        email: json["email"],
        mainIdea: json["mainIdea"],
        language: json["language"],
        style: EmailStyle.fromJson(json['style']),
        sender: json['sender'],
        receiver: json['receiver'],
        subject: json['subject']
      );
}
