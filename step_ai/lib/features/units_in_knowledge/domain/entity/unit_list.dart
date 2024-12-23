import 'package:step_ai/features/units_in_knowledge/domain/entity/unit.dart';

class UnitList {
  final List<Unit> units;

  UnitList({required this.units});
  factory UnitList.fromJson(Map<String, dynamic> json) {
    List<Unit> units = [];
    for (var unit in json['data']) {
      units.add(Unit.fromJson(unit));
    }
    return UnitList(units: units);
  }
}
