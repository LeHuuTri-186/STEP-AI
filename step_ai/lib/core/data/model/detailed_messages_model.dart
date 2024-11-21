class DetailedMessagesModel {
  String cursor;
  bool hasMore;
  int limit;
  List<MessageItem> items;
  DetailedMessagesModel({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });
  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'has_more': hasMore,
      'limit': limit,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
  factory DetailedMessagesModel.fromJson(Map<String, dynamic> json) {
    return DetailedMessagesModel(
      cursor: json['cursor'],
      hasMore: json['has_more'],
      limit: json['limit'],
      items: List<MessageItem>.from(
          json['items'].map((item) => MessageItem.fromJson(item))),
    );
  }
}

class MessageItem {
  String answer;
  int createdAt;
  List<String>? files;
  String query;
  MessageItem({
    required this.answer,
    required this.createdAt,
    this.files,
    required this.query,
  });
  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'createdAt': createdAt,
      'files': files,
      'query': query,
    };
  }

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      answer: json['answer'],
      createdAt: json['createdAt'],
      files: List<String>.from(json['files']),
      query: json['query'],
    );
  }
}
