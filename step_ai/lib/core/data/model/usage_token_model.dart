class UsageTokenModel {
  int availableTokens;
  int totalTokens;
  bool unlimited;
  DateTime date;
  UsageTokenModel(
      {required this.availableTokens,
      required this.totalTokens,
      required this.unlimited,
      required this.date});

  Map<String, dynamic> toJson() {
    return {
      'availableTokens': availableTokens,
      'totalTokens': totalTokens,
      'unlimited': unlimited,
      'date': date.toIso8601String(),
    };
  }
  factory UsageTokenModel.fromJson(Map<String, dynamic> json) {
    return UsageTokenModel(
      availableTokens: json['availableTokens'],
      totalTokens: json['totalTokens'],
      unlimited: json['unlimited'],
      date: DateTime.parse(json['date']),
    );
  }
}
