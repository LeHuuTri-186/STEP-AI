import 'package:step_ai/features/plan/data/model/plan_model.dart';
import 'package:step_ai/features/plan/domain/entity/plan.dart';

extension PlanConverter on Plan {
  PlanModel toPlanModel() {
    return PlanModel(name: name, monthlyTokens: monthlyTokens, dailyTokens: dailyTokens, annuallyTokens: annuallyTokens);
  }
}