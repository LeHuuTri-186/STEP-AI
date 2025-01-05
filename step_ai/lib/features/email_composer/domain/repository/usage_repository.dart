import 'package:step_ai/core/data/model/usage_token_model.dart';

abstract class UsageRepository {
  Future<UsageTokenModel> getUsageToken();
}