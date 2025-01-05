import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';
import 'package:step_ai/features/email_composer/domain/repository/response_email_repository.dart';

class GenerateResponseEmailUsecase extends UseCase<ResponseEmail, AiEmail> {

  final ResponseEmailRepository repository;

  GenerateResponseEmailUsecase({required this.repository});


  @override
  FutureOr<ResponseEmail> call({required AiEmail params}) {
    return repository.generateResponseEmail(aiEmail: params);
  }

}