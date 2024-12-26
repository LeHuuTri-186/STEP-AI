import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/compose_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';
import 'package:step_ai/features/email_composer/domain/repository/reponse_email_repository.dart';

class ComposeEmailUsecase extends UseCase<ResponseEmail, ComposeEmail> {

  final ResponseEmailRepository repository;

  ComposeEmailUsecase({required this.repository});

  @override
  FutureOr<ResponseEmail> call({required ComposeEmail params}) {
    return repository.composeEmail(composeEmail: params);
  }
}