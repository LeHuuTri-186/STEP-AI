import 'package:step_ai/features/plan/data/model/plan_model.dart';

import '../../domain/entity/plan.dart';

extension PlanModelConverter on PlanModel {
  Plan toPlanEntity() {
    return Plan(name, dailyTokens, monthlyTokens, annuallyTokens);
  }
}