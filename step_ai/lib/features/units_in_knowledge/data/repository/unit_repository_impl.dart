import 'package:step_ai/features/units_in_knowledge/data/network/unit_api.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/update_status_unit_param.dart';
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
      print(e);
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
}
