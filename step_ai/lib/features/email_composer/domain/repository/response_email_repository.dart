import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';

import '../entity/compose_email.dart';

abstract class ResponseEmailRepository {
  Future<ResponseEmail> generateResponseEmail({required AiEmail aiEmail});
  Future<List<String>> generateIdeasEmail({required AiEmail aiEmail});
  Future<ResponseEmail> composeEmail({required ComposeEmail composeEmail});
}