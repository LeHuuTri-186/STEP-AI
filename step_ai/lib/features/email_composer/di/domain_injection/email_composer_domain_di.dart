import 'package:get_it/get_it.dart';
import 'package:step_ai/features/email_composer/domain/repository/response_email_repository.dart';

import '../../domain/repository/usage_repository.dart';
import '../../domain/usecase/compose_email_usecase.dart';
import '../../domain/usecase/generate_email_response_usecase.dart';
import '../../domain/usecase/generate_idea_usecase.dart';
import '../../domain/usecase/get_usage_usecase.dart';

final getIt = GetIt.instance;

Future<void> initEmailComposerDomain() async {
  getIt.registerSingleton<ComposeEmailUsecase>(
      ComposeEmailUsecase(repository: getIt<ResponseEmailRepository>()));
  getIt.registerSingleton<GenerateResponseEmailUsecase>(
      GenerateResponseEmailUsecase(
          repository: getIt<ResponseEmailRepository>()));
  getIt.registerSingleton<GenerateIdeaUsecase>(
      GenerateIdeaUsecase(repository: getIt<ResponseEmailRepository>()));
  getIt.registerSingleton<GetUsageUsecase>(
      GetUsageUsecase(repo: getIt<UsageRepository>()));
}
