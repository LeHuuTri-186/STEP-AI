import 'package:flutter/material.dart';

import '../domain/entity/assistant.dart';

class AssistantNotifier with ChangeNotifier{
    final List<Assistant> _assistants = [
    Assistant(
        name: 'Claude 3 Haiku',
        id: 'claude-3-haiku-20240307',
        model: "dify",
        logoPath: "lib/core/assets/imgs/ai1.png"),
    Assistant(
        name: 'Claude 3 Sonnet',
        id: 'claude-3-sonnet-20240229',
        model: "dify",
        logoPath: "lib/core/assets/imgs/ai2.png"),
    Assistant(
        name: 'Gemini',
        id: 'gemini-1.5-flash-latest',
        model: "dify",
        logoPath: "lib/core/assets/imgs/gemini.png"),
    Assistant(
        name: 'ChatGPT 1.5 pro',
        id: 'gemini-1.5-pro-latest',
        model: "dify",
        logoPath: "lib/core/assets/imgs/gpt.png"),
    Assistant(
        name: 'GPT 4o',
        id: 'gpt-4o',
        model: "dify",
        logoPath: "lib/core/assets/imgs/ai5.png"),
    Assistant(
        name: 'GPT 4o Mini',
        id: 'gpt-4o-mini',
        model: "dify",
        logoPath: "lib/core/assets/imgs/ai6.png"),
  ];
  late String _currentAssistantId;
  AssistantNotifier() {
    _currentAssistantId = _assistants[0].id!;
  }

  String get currentAssistantId=> _currentAssistantId;

  void setCurrentAssistantId(String id) {
    _currentAssistantId = id;
    notifyListeners();
  }

  Assistant get currentAssistant => _assistants.firstWhere((element) => element.id == _currentAssistantId);

  List<Assistant> get assistants => _assistants;
}