import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_confluence_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_local_file_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_slack_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_web_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/delete_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/get_unit_list_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/update_status_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_confluence_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_drive_usecae.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_local_file_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_slack_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/upload_web_usecase.dart';

class UnitNotifier extends ChangeNotifier {
  GetUnitListUsecase _getUnitListUsecase;
  DeleteUnitUsecase _deleteUnitUsecase;
  UpdateStatusUnitUsecase _updateStatusUnitUsecase;

  UploadLocalFileUsecase _uploadLocalFileUsecase;
  UploadWebUsecase _uploadWebUsecase;
  UploadSlackUsecase _uploadSlackUsecase;
  UploadDriveUsecae _uploadDriveUsecae;
  UploadConfluenceUsecase _uploadConfluenceUsecase;

  TaskStatus taskStatus = TaskStatus.OK;
  void changeTaskStatus(TaskStatus taskStatus) {
    this.taskStatus = taskStatus;
    notifyListeners();
  }

  UnitNotifier(
      this._getUnitListUsecase,
      this._deleteUnitUsecase,
      this._updateStatusUnitUsecase,
      this._uploadLocalFileUsecase,
      this._uploadWebUsecase,
      this._uploadSlackUsecase,
      this._uploadDriveUsecae,
      this._uploadConfluenceUsecase);
  bool isLoading = false;
  String errorString = "";
  UnitList? unitList;
  Knowledge? currentKnowledge;

  Future<void> getUnitList() async {
    isLoading = true;
    notifyListeners();
    try {
      unitList = await _getUnitListUsecase.call(params: currentKnowledge!.id);
      unitList!.units
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      errorString = "";
    } catch (e) {
      errorString = e.toString();
      unitList = null;
      //print("Error in getUnitList in UnitNotifier: $errorString");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          errorString = "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteUnit(String idUnit) async {
    try {
      await _deleteUnitUsecase.call(
          params: DeleteUnitParam(
              idKnowledge: currentKnowledge!.id, idUnit: idUnit));
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      //print("Error in deleteUnit in unit notifier with error: $e");
      throw "Delete unit failed. Try again later";
    }
  }

  Future<void> updateStatusUnit(String unitId, bool status) async {
    try {
      await _updateStatusUnitUsecase.call(
          params: UpdateStatusUnitParam(id: unitId, status: status));
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      //print("Error in updateStatusUnit in unit notifier with error: $e");
      throw "Update status unit failed. Try again later";
    }
  }

  //Upload UNIT -------------------
  Future<void> uploadLocalFile(File file, MediaType mediaType) async {
    try {
      await _uploadLocalFileUsecase.call(
          params: UploadLocalFileParam(
              file: file,
              knowledgeId: currentKnowledge!.id,
              mediaType: mediaType));
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      //print("Error in uploadLocalFile in unit notifier with error: $e");
      throw e.toString();
    }
  }

  Future<void> uploadWeb(String webUrl, String unitName) async {
    try {
      await _uploadWebUsecase.call(
          params: UploadWebParam(
              knowledgeId: currentKnowledge!.id,
              unitName: unitName,
              webUrl: webUrl));
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response!.statusCode == 500) {
          throw "Url is not valid";
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      //print("Error in uploadweb in unit notifier with error: $e");
      throw e.toString();
    }
  }

  Future<void> uploadSlack(
      String nameSlack, String slackWorkspace, String slackBotToken) async {
    try {
      await _uploadSlackUsecase.call(
          params: UploadSlackParam(
              knowledgeId: currentKnowledge!.id,
              unitName: nameSlack,
              slackBotToken: slackBotToken,
              slackWorkspace: slackWorkspace));
    } catch (e) {
      //print("Error in upload Slack in unit notifier with error: $e");

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response!.statusCode == 400) {
          throw e.response!.data["details"][0]["issue"];
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      throw e.toString();
    }
  }

  Future<void> uploadDrive() async {}
  Future<void> uploadConfluence(
    String unitName,
    String wikiPageUrl,
    String confluenceUsername,
    String confluenceAccessToken,
  ) async {
    try {
      await _uploadConfluenceUsecase.call(
          params: UploadConfluenceParam(
              knowledgeId: currentKnowledge!.id,
              unitName: unitName,
              wikiPageUrl: wikiPageUrl,
              confluenceUsername: confluenceUsername,
              confluenceAccessToken: confluenceAccessToken));
    } catch (e) {
      //print("Error in upload Confluence in unit notifier with error: $e");
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw "Please check your internet connection";
        }
        if (e.response!.statusCode == 400) {
          throw e.response!.data["details"][0]["issue"];
        }
        if (e.response?.statusCode == 401) {
          changeTaskStatus(TaskStatus.UNAUTHORIZED);
        }
      }
      throw e.toString();
    }
  }

//------------------------------
  void updateCurrentKnowledge(Knowledge knowledge) {
    currentKnowledge = knowledge;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  //Using for loading indicator when switch disable/enable item in cupertino custom
  int numberLoadingItemSwitchCounter = 0;
  void incrementCupertinoSwitch() {
    numberLoadingItemSwitchCounter++;
    notifyListeners();
  }

  void decrementCupertinoSwitch() {
    if (numberLoadingItemSwitchCounter > 0) {
      numberLoadingItemSwitchCounter--;
      notifyListeners();
    }
  }

  //Utils
  void changeDisplayUnitsWhenSearching(String searchText) {
    unitList!.units.forEach((element) {
      if (element.name.toLowerCase().contains(searchText.toLowerCase())) {
        element.isDisplay = true;
      } else {
        element.isDisplay = false;
      }
    });
    notifyListeners();
  }
}
