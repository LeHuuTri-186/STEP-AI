import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';

abstract class UnitRepository {
  Future<UnitList> getUnitList(String idKnowledge);
  Future<void> deleteUnit(DeleteUnitParam deleteParam);
  Future<void> updateStatusUnit(UpdateStatusUnitParam updateStatusUnitParam);
}
