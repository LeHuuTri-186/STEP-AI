

import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class Message {
  Assistant assistant;
  String role;
  String? content;
  List<String>? files;
  Message({
    required this.assistant,
    required this.role,
    this.content,
    this.files,
  });
  // factory Message.fromJson(Map<String, dynamic> json) {
  //   return Message(
  //     assistant: Assistant.fromJson(json['assistant']),
  //     role: json['role'],
  //     content: json['content'],
  //     files: json['files'],
  //   );
  // }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'assistant': assistant.toJson(),
  //     'role': role,
  //     'content': content,
  //     'files': files,
  //   };
  // }
}
