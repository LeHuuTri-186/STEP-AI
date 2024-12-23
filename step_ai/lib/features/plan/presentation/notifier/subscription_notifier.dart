import 'package:flutter/widgets.dart';
import 'package:step_ai/features/plan/domain/usecases/get_subscription_usecase.dart';

import '../../../authentication/domain/usecase/logout_usecase.dart';
import '../../domain/entity/plan.dart';

class SubscriptionNotifier extends ChangeNotifier {
  Plan? plan;
  
  final LogoutUseCase _logoutUseCase;
  final GetSubscriptionUsecase _subscriptionUsecase;
  SubscriptionNotifier(this._logoutUseCase, this._subscriptionUsecase);
  
  Future<void> getPlan() async {
    try {
      plan = await _subscriptionUsecase.call();
    } catch(e) {
      _logoutUseCase.call(params: null);
    } finally {
      notifyListeners();
    }
  }
}