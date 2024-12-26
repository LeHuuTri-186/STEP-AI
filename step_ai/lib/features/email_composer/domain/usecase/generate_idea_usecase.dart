import 'dart:async';

import 'package:step_ai/core/usecase/use_case.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';
import 'package:step_ai/features/email_composer/domain/repository/reponse_email_repository.dart';

class GenerateIdeaUsecase extends UseCase<List<String>, AiEmail> {

  final ResponseEmailRepository repository;

  GenerateIdeaUsecase({required this.repository});


  @override
  FutureOr<List<String>> call({required AiEmail params}) {
    return repository.generateIdeasEmail(aiEmail: params);
  }
}