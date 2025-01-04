import 'package:get_it/get_it.dart';
import 'package:step_ai/features/email_composer/domain/repository/response_email_repository.dart';
import 'package:step_ai/features/email_composer/domain/repository/usage_repository.dart';
import 'package:step_ai/features/email_composer/domain/usecase/compose_email_usecase.dart';
import 'package:step_ai/features/email_composer/domain/usecase/generate_email_response_usecase.dart';
import 'package:step_ai/features/email_composer/domain/usecase/generate_idea_usecase.dart';
import 'package:step_ai/features/email_composer/domain/usecase/get_usage_usecase.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/email_composer_notifier.dart';
import 'package:step_ai/features/email_composer/presentation/notifier/usage_token_notifier.dart';

final getIt = GetIt.instance;

Future<void> initEmailComposerPresentation() async {
  getIt.registerSingleton<EmailComposerNotifier>(EmailComposerNotifier(generateResponseEmailUsecase: getIt<GenerateResponseEmailUsecase>(), generateIdeaUsecase: getIt<GenerateIdeaUsecase>()));
  getIt.registerSingleton<UsageTokenNotifier>(UsageTokenNotifier(usageTokenUsecase: getIt<GetUsageUsecase>()));
}