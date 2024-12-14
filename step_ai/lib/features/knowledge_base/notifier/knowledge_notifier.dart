import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/edit_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/add_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/delete_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/edit_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';

class KnowledgeNotifier with ChangeNotifier {
  GetKnowledgeListUsecase _getKnowledgeListUsecase;
  AddKnowledgeUsecase _addKnowledgeUsecase;
  DeleteKnowledgeUsecase _deleteKnowledgeUsecase;
  EditKnowledgeUsecase _editKnowledgeUsecase;
  KnowledgeNotifier(this._getKnowledgeListUsecase, this._addKnowledgeUsecase,
      this._deleteKnowledgeUsecase, this._editKnowledgeUsecase);
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
    try {
      await _addKnowledgeUsecase.call(
          params: KnowledgeParam(
              knowledgeName: knowledgeName, description: knowledgeDescription));
    } catch (e) {
      if (e is DioException) {
        throw e.response?.data["details"][0]['issue'] ??
            "Có lỗi xảy ra. Thử lại sau addNewKnowledge";
      }
      errorString = "Có lỗi xảy ra. Thử lại sau addNewKnowledge";
      print("Error in addNewKnowledge in knowledge notifier with error: $e");
    }
  }

  Future<void> updateKnowledge(
      String id, String knowledgeName, String? knowledgeDescription) async {
    //Check name is used because server not check this condition
    knowledgeList!.knowledgeList.forEach((element) {
      if (element.knowledgeName == knowledgeName && element.id != id) {
        throw "Name knowledge is used";
      }
    });

    try {
      await _editKnowledgeUsecase.call(
          params: EditKnowledgeParam(
              id: id,
              knowledgeParam: KnowledgeParam(
                  knowledgeName: knowledgeName,
                  description: knowledgeDescription)));
    } catch (e) {
      errorString = "Có lỗi xảy ra. Thử lại sau addNewKnowledge";
      print("Error in addNewKnowledge in knowledge notifier with error: $e");
    }
  }

  Future<void> deleteKnowledge(String id) async {
    try {
      await _deleteKnowledgeUsecase.call(params: id);
    } catch (e) {
      errorString = "Có lỗi xảy ra. Thử lại sau addNewKnowledge";
      print("Error in deleteKnowledge in knowledge notifier with error: $e");
    }
  }
}