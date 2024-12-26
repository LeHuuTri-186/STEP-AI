import 'dart:convert';

import 'package:step_ai/features/email_composer/data/model/response_email_model.dart';

class ResponseEmail {
  final String email;
  final int remainingUsage;

  ResponseEmail({
    required this.email,
    required this.remainingUsage,
  });

  ResponseEmail copyWith({
    String? email,
    int? remainingUsage,
  }) =>
      ResponseEmail(
        email: email ?? this.email,
        remainingUsage: remainingUsage ?? this.remainingUsage,
      );

  factory ResponseEmail.fromJson(String str) => ResponseEmail.fromMap(json.decode(str));
  factory ResponseEmail.fromModel(ResponseEmailModel model) => ResponseEmail(email: model.email, remainingUsage: model.remainingUsage);

  String toJson() => json.encode(toMap());

  factory ResponseEmail.fromMap(Map<String, dynamic> json) => ResponseEmail(
    email: json["email"],
    remainingUsage: json["remainingUsage"],
  );

  Map<String, dynamic> toMap() => {
    "email": email,
    "remainingUsage": remainingUsage,
  };
}