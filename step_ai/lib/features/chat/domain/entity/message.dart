import 'dart:io';

import 'package:dio/dio.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class Message {
  Assistant assistant;
  String role;
  String? content;
  List<File>? files;
  Message({
    required this.assistant,
    required this.role,
    this.content,
    this.files,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      assistant: Assistant.fromJson(json['assistant']),
      role: json['role'],
      content: json['content'],
      files: json['files'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'assistant': assistant.toJson(),
      'role': role,
      'content': content ?? '',
    };

    if (files != null && files!.isNotEmpty) {
      json['files'] = files;
    }

    return json;
  }
}
