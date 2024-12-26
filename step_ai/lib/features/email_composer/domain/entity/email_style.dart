import 'dart:convert';

class EmailStyle {
  final String formality;
  final String length;
  final String tone;

  EmailStyle({
    required this.formality,
    required this.length,
    required this.tone,
  });

  EmailStyle copyWith({
    String? formality,
    String? length,
    String? tone,
  }) =>
      EmailStyle(
        formality: formality ?? this.formality,
        length: length ?? this.length,
        tone: tone ?? this.tone,
      );

  factory EmailStyle.fromJson(String str) => EmailStyle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmailStyle.fromMap(Map<String, dynamic> json) => EmailStyle(
    formality: json["formality"],
    length: json["length"],
    tone: json["tone"],
  );

  Map<String, dynamic> toMap() => {
    "formality": formality,
    "length": length,
    "tone": tone,
  };
}