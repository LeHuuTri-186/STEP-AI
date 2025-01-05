class PreviewMessage {
  final String role;
  final int createdAt;
  final List<PreviewContent> content;

  PreviewMessage({
    required this.role,
    required this.createdAt,
    required this.content,
  });

  factory PreviewMessage.fromJson(Map<String, dynamic> json) {
    return PreviewMessage(
      role: json['role'],
      createdAt: json['createdAt'],
      content: (json['content'] as List)
          .map((content) => PreviewContent.fromJson(content))
          .toList(),
    );
  }
}

class PreviewContent {
  final String type;
  final TextData text;

  PreviewContent({
    required this.type,
    required this.text,
  });

  factory PreviewContent.fromJson(Map<String, dynamic> json) {
    return PreviewContent(
      type: json['type'],
      text: TextData.fromJson(json['text']),
    );
  }
}

class TextData {
  final String value;
  final List<dynamic> annotations;

  TextData({
    required this.value,
    required this.annotations,
  });

  factory TextData.fromJson(Map<String, dynamic> json) {
    return TextData(
      value: json['value'],
      annotations: json['annotations'],
    );
  }
}
