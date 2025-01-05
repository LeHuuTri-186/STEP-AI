import 'dart:convert';

class ResponseEmailModel {
  final String email;
  final int remainingUsage;

  ResponseEmailModel({
    required this.email,
    required this.remainingUsage,
  });

  ResponseEmailModel copyWith({
    String? email,
    int? remainingUsage,
  }) =>
      ResponseEmailModel(
        email: email ?? this.email,
        remainingUsage: remainingUsage ?? this.remainingUsage,
      );

  factory ResponseEmailModel.fromJson(String str) => ResponseEmailModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseEmailModel.fromMap(Map<String, dynamic> json) => ResponseEmailModel(
    email: json["email"],
    remainingUsage: json["remainingUsage"],
  );

  factory ResponseEmailModel.fromMapComposer(Map<String, dynamic> json) => ResponseEmailModel(
    email: json["message"],
    remainingUsage: json["remainingUsage"],
  );

  Map<String, dynamic> toMap() => {
    "email": email,
    "remainingUsage": remainingUsage,
  };
}