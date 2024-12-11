import 'package:flutter/material.dart';

class EditKnowledgeDialogNotifier extends ChangeNotifier {
  bool isLoadingWhenEditNewKnowledge = false;
  String errorDisplayWhenNameIsUsed = "";
  void updateNumberTextInTextFiled() {
    notifyListeners();
  }

  void setIsLoadingWhenEditKnowledge(bool isLoading) {
    isLoadingWhenEditNewKnowledge = isLoading;
    notifyListeners();
  }
  void setErrorDisplayWhenNameIsUsed(String error) {
    errorDisplayWhenNameIsUsed = error;
    notifyListeners();
  }
}
