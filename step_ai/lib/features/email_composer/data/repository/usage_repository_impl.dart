import 'package:dio/dio.dart';
import 'package:step_ai/core/data/model/usage_token_model.dart';
import 'package:step_ai/features/email_composer/data/network/api_usage.dart';
import 'package:step_ai/features/email_composer/domain/repository/usage_repository.dart';

class UsageRepositoryImpl extends UsageRepository {

  final ApiUsage _apiUsage;

  UsageRepositoryImpl({required ApiUsage apiUsage}) : _apiUsage = apiUsage;

  @override
  Future<UsageTokenModel> getUsageToken() async {
    Response respond = await _apiUsage.getUsage();

    return UsageTokenModel.fromJson(respond.data);
  }
}