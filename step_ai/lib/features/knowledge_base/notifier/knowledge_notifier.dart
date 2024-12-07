import 'package:flutter/material.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';

class KnowledgeNotifier with ChangeNotifier {
  GetKnowledgeListUsecase _getKnowledgeListUsecase;
  KnowledgeNotifier(this._getKnowledgeListUsecase);

  bool isLoadingKnowledgeList = false;
  KnowledgeList? knowledgeList;
  Future<void> getKnowledgeList() async {
    isLoadingKnowledgeList = true;
    notifyListeners();
    try {
      knowledgeList = await _getKnowledgeListUsecase.call(params: null);
    } catch (e) {
      knowledgeList = null;
      print("Error in getKnowledgeList in knowledge notifier with error: $e");
    } finally {
      isLoadingKnowledgeList = false;
      notifyListeners();
    }
  }
}
