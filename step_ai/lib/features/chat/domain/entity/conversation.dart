class Conversation {
  String id;
  String? title;
  int? createAt;
  Conversation({required this.id, this.title, this.createAt});
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      createAt: json['createAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createAt': createAt,
    };
  }
}