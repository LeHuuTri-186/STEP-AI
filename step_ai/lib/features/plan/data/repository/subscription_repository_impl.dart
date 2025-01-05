import 'package:dio/dio.dart';
import 'package:step_ai/features/plan/data/extension/PlanModelConverter.dart';
import 'package:step_ai/features/plan/data/model/plan_model.dart';
import 'package:step_ai/features/plan/data/network/api_subscription.dart';
import 'package:step_ai/features/plan/domain/entity/plan.dart';
import 'package:step_ai/features/plan/domain/repository/subscription_repository.dart';

import '../../../../config/constants.dart';

class SubscriptionRepositoryImpl extends SubscriptionRepository {
  final ApiSubscription _apiSubscription;
  SubscriptionRepositoryImpl(this._apiSubscription);
  @override
  Future<Plan> getCurrentPlan() async {
    late Response<dynamic> response;
    try {
      response = await _apiSubscription.getUsage(Constant.usageEndpoint);
    }catch (e) {
      throw("Error getting usage");
    }


    return PlanModel.fromJson(response.data).toPlanEntity();
  }
}