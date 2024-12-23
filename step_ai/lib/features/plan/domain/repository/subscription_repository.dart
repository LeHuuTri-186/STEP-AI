import '../entity/plan.dart';

abstract class SubscriptionRepository {
  Future<Plan> getCurrentPlan();
}