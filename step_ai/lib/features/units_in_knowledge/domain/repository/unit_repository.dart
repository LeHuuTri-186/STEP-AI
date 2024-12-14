import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_confluence_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_drive_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_local_file_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_slack_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/upload_web_param.dart';

abstract class UnitRepository {
  Future<UnitList> getUnitList(String idKnowledge);
  Future<void> deleteUnit(DeleteUnitParam deleteParam);
  Future<void> updateStatusUnit(UpdateStatusUnitParam updateStatusUnitParam);
  Future<void> uploadLocalFile(UploadLocalFileParam uploadLocalFileParam);
  Future<void> uploadWeb(UploadWebParam uploadWebParam);
  Future<void> uploadSlack(UploadSlackParam uploadSlackParam);
  Future<void> uploadDrive(UploadDriveParam uploadDriveParam);
  Future<void> uploadConfluence(UploadConfluenceParam uploadConfluenceParam);

}