import 'package:flutter/material.dart';

class AddKnowledgeDialogNotifier extends ChangeNotifier {
  bool isLoadingWhenCreateNewKnowledge = false;
  String errorDisplayWhenNameIsUsed = "";
  void updateNumberTextInTextFiled() {
    notifyListeners();
  }

  void setIsLoadingWhenCreateNewKnowledge(bool isLoading) {
    isLoadingWhenCreateNewKnowledge = isLoading;
    notifyListeners();
  }
  void setErrorDisplayWhenNameIsUsed(String error) {
    errorDisplayWhenNameIsUsed = error;
    notifyListeners();
  }
}
