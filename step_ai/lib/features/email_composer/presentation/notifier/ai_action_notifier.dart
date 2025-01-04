

import 'package:flutter/cupertino.dart';
import 'package:step_ai/features/email_composer/domain/entity/compose_email.dart';
import 'package:step_ai/features/email_composer/domain/usecase/compose_email_usecase.dart';

import '../../domain/entity/response_email.dart';

class AiActionNotifier extends ChangeNotifier {
  List<String> ideas = [];
  var isGeneratingEmail = false;
  var hasError = false;
  List<ResponseEmail> emailList = [];
  int currentEmailIndex = -1;
  final ComposeEmailUsecase _composeEmailUsecase;

  AiActionNotifier({required ComposeEmailUsecase composeEmailUsecase}) : _composeEmailUsecase = composeEmailUsecase;


  Future<void> composeEmail(ComposeEmail email) async {
    isGeneratingEmail = true;
    notifyListeners();

    try {
      emailList.add(await _composeEmailUsecase.call(params: email));
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

  void nextEmail() {
    if (currentEmailIndex < emailList.length - 1) {
      currentEmailIndex++;
      notifyListeners();
    }
  }
}
