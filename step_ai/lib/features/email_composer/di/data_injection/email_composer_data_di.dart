import 'package:get_it/get_it.dart';
import 'package:step_ai/features/email_composer/data/network/api_response_email.dart';
import 'package:step_ai/features/email_composer/data/network/api_usage.dart';

import '../../data/repository/response_email_repository_impl.dart';
import '../../data/repository/usage_repository_impl.dart';
import '../../domain/repository/response_email_repository.dart';
import '../../domain/repository/usage_repository.dart';

final getIt = GetIt.instance;

Future<void> initEmailComposerData() async {
  getIt.registerSingleton<ApiResponseEmail>(ApiResponseEmail());
  getIt.registerSingleton<ApiUsage>(ApiUsage());
  getIt.registerSingleton<ResponseEmailRepository>(ResponseEmailRepositoryImpl(getIt<ApiResponseEmail>()));
  getIt.registerSingleton<UsageRepository>(UsageRepositoryImpl(apiUsage: getIt<ApiUsage>()));
}