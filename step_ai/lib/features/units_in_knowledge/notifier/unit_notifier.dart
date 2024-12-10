import 'package:flutter/material.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit_list.dart';
import 'package:step_ai/features/units_in_knowledge/domain/params/delete_unit_param.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/delete_unit_usecase.dart';
import 'package:step_ai/features/units_in_knowledge/domain/usecase/get_unit_list_usecase.dart';

class UnitNotifier extends ChangeNotifier {
  GetUnitListUsecase _getUnitListUsecase;
  DeleteUnitUsecase _deleteUnitUsecase;
  UnitNotifier(this._getUnitListUsecase, this._deleteUnitUsecase);
  bool isLoading = false;
  String errorString = "";
  UnitList? unitList;
  Knowledge? currentKnowledge;

  Future<void> getUnitList() async {
    isLoading = true;
    notifyListeners();
    try {
      unitList = await _getUnitListUsecase.call(params: currentKnowledge!.id);
      errorString = "";
    } catch (e) {
      errorString = e.toString();
      unitList = null;
      print("Error in getUnitList in UnitNotifier: $errorString");
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
      errorString = "Có lỗi xảy ra. Thử lại sau deleteUnit";
      print("Error in deleteUnit in unit notifier with error: $e");
    }
  }
  void updateCurrentKnowledge(Knowledge knowledge) {
    currentKnowledge = knowledge;
    notifyListeners();
  }
}
