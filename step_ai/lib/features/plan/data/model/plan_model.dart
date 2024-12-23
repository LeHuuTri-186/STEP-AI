class PlanModel {
  final String name;
  final int dailyTokens;
  final int monthlyTokens;
  final int annuallyTokens;
  PlanModel({required this.name, required this.dailyTokens, required this.monthlyTokens, required this.annuallyTokens});

  factory PlanModel.fromJson(Map<String, dynamic> json){
    return PlanModel(
      name: json['name'],
      dailyTokens: json['dailyTokens'],
      monthlyTokens: json['monthlyTokens'],
      annuallyTokens: json['annuallyTokens']
    );
  }
}