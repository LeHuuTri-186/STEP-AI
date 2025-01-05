import 'package:flutter/material.dart';
import 'package:step_ai/features/email_composer/domain/entity/ai_email.dart';
import 'package:step_ai/features/email_composer/domain/entity/response_email.dart';
import 'package:step_ai/features/email_composer/domain/usecase/generate_email_response_usecase.dart';
import 'package:step_ai/features/email_composer/domain/usecase/generate_idea_usecase.dart';

class EmailComposerNotifier extends ChangeNotifier {
  List<String> ideas = [];
  String emailContent = "";
  var isGeneratingIdea = false;
  var isGeneratingEmail = false;
  var hasError = false;
  List<ResponseEmail> emailList = [];
  int currentEmailIndex = -1;
  final GenerateResponseEmailUsecase _generateResponseEmailUsecase;
  final GenerateIdeaUsecase _generateIdeaUsecase;

  EmailComposerNotifier(
      {required GenerateResponseEmailUsecase generateResponseEmailUsecase,
      required GenerateIdeaUsecase generateIdeaUsecase})
      : _generateResponseEmailUsecase = generateResponseEmailUsecase,
        _generateIdeaUsecase = generateIdeaUsecase;

  Future<void> generateIdeas(AiEmail email) async {
    isGeneratingIdea = true;
    notifyListeners();

    try {
      ideas = await _generateIdeaUsecase.call(params: email);
    } catch (e) {
      hasError = true;
    } finally {
      isGeneratingIdea = false;
      notifyListeners();
    }
  }

  Future<void> generateEmail(AiEmail email) async {
    isGeneratingEmail = true;
    notifyListeners();

    try {
      emailList.add(await _generateResponseEmailUsecase.call(params: email));
      currentEmailIndex++;
    } catch (e) {
      hasError = true;
    } finally {
      isGeneratingEmail = false;
      notifyListeners();
    }
  }

  void previousEmail() {
    if (currentEmailIndex > 0) {
      currentEmailIndex--;
      notifyListeners();
    }
  }

  void clearIdeas() {
    ideas.clear();
    notifyListeners();
  }

  void nextEmail() {
    if (currentEmailIndex < emailList.length - 1) {
      currentEmailIndex++;
      notifyListeners();
    }
  }
}
