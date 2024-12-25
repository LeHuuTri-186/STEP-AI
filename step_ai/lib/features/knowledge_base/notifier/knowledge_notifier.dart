import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/knowledge_base/domain/params/edit_knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/params/knowledge_param.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/add_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/delete_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/edit_knowledge_usecase.dart';
import 'package:step_ai/features/knowledge_base/domain/usecase/get_knowledge_list_usecase.dart';

import '../domain/params/get_knowledges_param.dart';

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
  int limit = 0;
  bool hasNext = false;
  TaskStatus taskStatus = TaskStatus.OK;
  void reset() {
    limit = 0;
    hasNext = false;
  }

  void changeTaskStatus(TaskStatus taskStatus) {
    this.taskStatus = taskStatus;
    notifyListeners();
  }

  Future<void> getKnowledgeList() async {
    isLoadingKnowledgeList = true;
    notifyListeners();
    try {
      // limit += 5;
      final knowledgeListModel = await _getKnowledgeListUsecase.call(
          params: GetKnowledgesParam(limit: 50));
      knowledgeList = KnowledgeList.fromModel(knowledgeListModel);
      knowledgeList!.knowledgeList.sort((a, b) => a.knowledgeName
          .toLowerCase()
          .compareTo(b.knowledgeName.toLowerCase()));

      hasNext = knowledgeListModel.meta.hasNext;
      errorString = "";
    } catch (e) {
      knowledgeList = null;
      limit = 0;
      hasNext = false;
      errorString = "Have error. Try again  Get Knowledge";
      print("Error in getKnowledgeList in knowledge notifier with error: $e");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          errorString = "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
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
        if (e.response?.statusCode == 400) {
          throw e.response?.data["details"][0]['issue'] ??
              "Have error. Try again addNewKnowledge";
        }
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      print("Error in addNewKnowledge in knowledge notifier with error: $e");
      throw "Have error. Try again later: Add Knowledge";
      // notifyListeners();
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
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      print("Error in EditKnowledge in knowledge notifier with error: $e");
      throw "Have error. Try again later: Edit Knowledge";
    }
  }

  Future<void> deleteKnowledge(String id) async {
    try {
      await _deleteKnowledgeUsecase.call(params: id);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      print("Error in deleteKnowledge in knowledge notifier with error: $e");
      throw "Have error Delete Knowledge. Try again";
    }
  }

  void changeDisplayKnowledgeWhenSearching(String searchText) {
    knowledgeList!.knowledgeList.forEach((element) {
      if (element.knowledgeName
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        element.isDisplay = true;
      } else {
        element.isDisplay = false;
      }
    });
    notifyListeners();
  }
}
