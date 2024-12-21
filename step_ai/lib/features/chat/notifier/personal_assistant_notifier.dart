import 'package:flutter/material.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';

class PersonalAssistantNotifier with ChangeNotifier{
  List<Assistant?> personalAssistants = [];
  bool isPersonal = false;

  String? _currentAssistantId;
  PersonalAssistantNotifier() {
    if (personalAssistants.isEmpty) {
      _currentAssistantId = null;
    }
    else {
      _currentAssistantId = personalAssistants[0]?.id;
    }
  }

  String? get currentAssistantId=> _currentAssistantId;

  void setCurrentAssistantId(String id) {
    _currentAssistantId = id;
    notifyListeners();
  }

  Assistant? get currentAssistant => personalAssistants.firstWhere((element) => element?.id == _currentAssistantId);

  List<Assistant?> get assistants => personalAssistants;

  void addAssistant(Assistant assistant) {
    personalAssistants = List.from(personalAssistants)..add(assistant);
    notifyListeners(); // Thông báo sau khi cập nhật danh sách
  }

  void removeAssistant(Assistant assistant){
    personalAssistants = List.from(personalAssistants)..remove(assistant);
    notifyListeners();
  }

  void changePersonalCheck(bool value) {
    isPersonal = value;
    notifyListeners();
  }

  void reset(){
    isPersonal = false;
    _currentAssistantId = null;
    personalAssistants = [];
    notifyListeners();
  }
}