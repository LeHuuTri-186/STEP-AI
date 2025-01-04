import 'package:dio/dio.dart';
import 'package:step_ai/features/email_composer/data/network/api_response_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/compose_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';

import '../../domain/repository/response_email_repository.dart';
import '../model/response_email_model.dart';

class ResponseEmailRepositoryImpl extends ResponseEmailRepository {

  final ApiResponseEmail _apiResponseEmail;

  ResponseEmailRepositoryImpl(this._apiResponseEmail);

  @override
  Future<ResponseEmail> generateResponseEmail({required AiEmail aiEmail}) async {

    Map<String, dynamic> payload = {
      "mainIdea": aiEmail.mainIdea,
      if (aiEmail.assistant != null) "assistant": aiEmail.assistant!.toJson(),
      "email": aiEmail.email,
      "action": aiEmail.action,
      "metadata": {
        "context": [],
        if (aiEmail.subject != null) "subject": aiEmail.subject,
        if (aiEmail.sender != null) "sender": aiEmail.sender,
        if (aiEmail.receiver != null) "receiver": aiEmail.receiver,
        "style": aiEmail.style.toMap(),
        "language": aiEmail.language,
      }
    };

    Response response = await _apiResponseEmail.postAiEmail(payload);

    ResponseEmailModel responseEmail = ResponseEmailModel.fromMap(response.data);

    return ResponseEmail.fromModel(responseEmail);
  }

  @override
  Future<List<String>> generateIdeasEmail({required AiEmail aiEmail}) async {
    Map<String, dynamic> payload = {
      if (aiEmail.assistant != null) "assistant": aiEmail.assistant!.toJson(),
      "email": aiEmail.email,
      "action": aiEmail.action,
      "metadata": {
        "context": [],
        if (aiEmail.subject != null) "subject": aiEmail.subject,
        if (aiEmail.sender != null) "sender": aiEmail.sender,
        if (aiEmail.receiver != null) "receiver": aiEmail.receiver,
        "language": aiEmail.language,
      }
    };

    Response response = await _apiResponseEmail.postSuggestionRequest(payload);

    return List<String>.from(response.data['ideas']);
  }

  @override
  Future<ResponseEmail> composeEmail({required ComposeEmail composeEmail}) async {
    Map<String, dynamic> payload = {
      if (composeEmail.assistant != null) "assistant": composeEmail.assistant!.toJson(),
      if (composeEmail.action != "") "action": composeEmail.action,
      "type": composeEmail.type,
      "content": composeEmail.content,
      "metadata": {
        if (composeEmail.language != null) "translateTo": composeEmail.language
      }
    };


    print(payload);

    late Response response;
    try {
      response = await _apiResponseEmail.postComposeEmailRequest(payload);
    } catch(e) {
      print(e);
    }


    ResponseEmailModel responseEmail = ResponseEmailModel.fromMapComposer(response.data);

    return ResponseEmail.fromModel(responseEmail);
  }
}