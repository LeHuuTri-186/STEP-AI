import 'package:dio/dio.dart';
import 'package:step_ai/features/units_in_knowledge/data/network/unit_api.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_confluence_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_drive_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_local_file_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_slack_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_web_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/repository/unit_repository.dart';

class UnitRepositoryImpl extends UnitRepository {
  UnitApi _unitApi;
  UnitRepositoryImpl(this._unitApi);
  @override
  Future<UnitList> getUnitList(String idKnowledge) async {
    Map<String, dynamic> queryParams = {
      "limit": 10,
    };
    try {
      final response = await _unitApi.get(
          '/kb-core/v1/knowledge/$idKnowledge/units',
          queryParams: queryParams);
      UnitList unitList = UnitList.fromJson(response.data);
      return unitList;
    } catch (e) {
      //print(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteUnit(DeleteUnitParam deleteParam) {
    return _unitApi.delete(
        "/kb-core/v1/knowledge/${deleteParam.idKnowledge}/units/${deleteParam.idUnit}");
  }

  @override
  Future<void> updateStatusUnit(UpdateStatusUnitParam updateStatusUnitParam) {
    return _unitApi.patch(
        "/kb-core/v1/knowledge/units/${updateStatusUnitParam.id}/status",
        data: {'status': updateStatusUnitParam.status});
  }

  //Upload Unit--------------

  @override
  Future<void> uploadLocalFile(
      UploadLocalFileParam uploadLocalFileParam) async {
    final formData = FormData();
    formData.files.add(
      MapEntry(
        'file',
        await MultipartFile.fromFile(uploadLocalFileParam.file.path,
            filename: uploadLocalFileParam.file.path.split('/').last,
            contentType: uploadLocalFileParam.mediaType),
      ),
    );
    await _unitApi.postFile(
        "/kb-core/v1/knowledge/${uploadLocalFileParam.knowledgeId}/local-file",
        data: formData);
  }

  @override
  Future<void> uploadWeb(UploadWebParam uploadWebParam) {
    return _unitApi
        .post("/kb-core/v1/knowledge/${uploadWebParam.knowledgeId}/web", data: {
      "unitName": uploadWebParam.unitName,
      "webUrl": uploadWebParam.webUrl
    });
  }

  @override
  Future<void> uploadConfluence(UploadConfluenceParam uploadConfluenceParam) {
    return _unitApi.post(
        "/kb-core/v1/knowledge/${uploadConfluenceParam.knowledgeId}/confluence",
        data: {
          "unitName": uploadConfluenceParam.unitName,
          "wikiPageUrl": uploadConfluenceParam.wikiPageUrl,
          "confluenceUsername": uploadConfluenceParam.confluenceUsername,
          "confluenceAccessToken": uploadConfluenceParam.confluenceAccessToken
        });
  }

  @override
  Future<void> uploadDrive(UploadDriveParam uploadDriveParam) {
    // TODO: implement uploadDrive
    throw UnimplementedError();
  }

  @override
  Future<void> uploadSlack(UploadSlackParam uploadSlackParam) {
    // TODO: implement uploadSlack
    return _unitApi.post(
        "/kb-core/v1/knowledge/${uploadSlackParam.knowledgeId}/slack",
        data: {
          "unitName": uploadSlackParam.unitName,
          "slackWorkspace": uploadSlackParam.slackWorkspace,
          "slackBotToken": uploadSlackParam.slackBotToken
        });
  }
}
