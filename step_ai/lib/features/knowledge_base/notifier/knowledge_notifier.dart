import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/add_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/add_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';

class KnowledgeNotifier with ChangeNotifier {
  GetKnowledgeListUsecase _getKnowledgeListUsecase;
  AddKnowledgeUsecase _addKnowledgeUsecase;
  KnowledgeNotifier(this._getKnowledgeListUsecase, this._addKnowledgeUsecase);
  String errorString = "";
  bool isLoadingKnowledgeList = false;
  KnowledgeList? knowledgeList;

  Future<void> getKnowledgeList() async {
    isLoadingKnowledgeList = true;
    notifyListeners();
    try {
      knowledgeList = await _getKnowledgeListUsecase.call(params: null);
      errorString = "";
    } catch (e) {
      knowledgeList = null;
      errorString = "Có lỗi xảy ra. Thử lại sau getKnowledgeList";
      print("Error in getKnowledgeList in knowledge notifier with error: $e");
    } finally {
      isLoadingKnowledgeList = false;
      notifyListeners();
    }
  }

  Future<void> addNewKnowledge(
      String knowledgeName, String? knowledgeDescription) async {
    isLoadingKnowledgeList = true;
    notifyListeners();
    try {
      await _addKnowledgeUsecase.call(
          params: AddKnowledgeParam(
              knowledgeName: knowledgeName, description: knowledgeDescription));
    } catch (e) {
      if (e is DioException) {
        throw e.response?.data["details"][0]['issue'] ??
            "Có lỗi xảy ra. Thử lại sau addNewKnowledge";
      }
      errorString = "Có lỗi xảy ra. Thử lại sau addNewKnowledge";
      print("Error in addNewKnowledge in knowledge notifier with error: $e");
    } finally {
      isLoadingKnowledgeList = false;
      notifyListeners();
    }
  }
}
