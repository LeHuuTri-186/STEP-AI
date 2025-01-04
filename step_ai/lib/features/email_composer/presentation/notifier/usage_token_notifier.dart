import 'package:flutter/cupertino.dart';
import 'package:step_ai/core/data/model/usage_token_model.dart';

import '../../domain/usecase/get_usage_usecase.dart';

class UsageTokenNotifier extends ChangeNotifier {
  final GetUsageUsecase _usageTokenUsecase;
  UsageTokenModel? model;
  bool hasError = false;

  UsageTokenNotifier({required GetUsageUsecase usageTokenUsecase}) : _usageTokenUsecase = usageTokenUsecase;

  Future<void> loadUsageToken() async {
    try {
      model = await _usageTokenUsecase.call();
    } catch (e) {
      hasError = true;
    } finally {
      notifyListeners();
    }
  }
}