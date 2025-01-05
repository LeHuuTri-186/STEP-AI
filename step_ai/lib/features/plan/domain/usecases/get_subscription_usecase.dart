import 'dart:async';

import 'package:step_ai/core/usecases/use_case.dart';
import 'package:step_ai/features/plan/domain/repository/subscription_repository.dart';

import '../entity/plan.dart';

class GetSubscriptionUsecase extends NoParamUseCase<Plan>{
  SubscriptionRepository repository;
  GetSubscriptionUsecase(this.repository);

  @override
  Future<Plan> call() async {
    return await repository.getCurrentPlan();
  }
}