class CurrentUserModel{
  final String id;
  final String email;
  final String userName;

  CurrentUserModel({required this.id, required this.email, required this.userName});

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      id: json['id'] ?? 'Default ID',
      email: json['email'] ?? 'Default Email',
      userName: json['username'] ?? 'Default Username',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
    };
  }

}