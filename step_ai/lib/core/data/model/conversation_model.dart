class ConversationModel {
  String cursor;
  bool hasMore;
  int limit;
  List<Item> items;
  ConversationModel(
      {required this.cursor,
      required this.hasMore,
      required this.limit,
      required this.items});
  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'hasMore': hasMore,
      'limit': limit,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      cursor: json['cursor'],
      hasMore: json['hasMore'],
      limit: json['limit'],
      items: List<Item>.from(json['items'].map((item) => Item.fromJson(item))),
    );
  }
}

class Item {
  String? title;
  String? id;
  int? createdAt;
  Item({this.title, this.id, this.createdAt});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'createdAt': createdAt,
    };
  }
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }
}
