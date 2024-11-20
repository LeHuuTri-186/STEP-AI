class Conversation {
  String id;
  String? title;
  int? createdAt;
  Conversation({required this.id, this.title, this.createdAt});
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      createdAt: json['createAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createAt': createdAt,
    };
  }
}