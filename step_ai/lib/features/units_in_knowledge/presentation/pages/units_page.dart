import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/button_add_new_unit.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/unit_listview.dart';

class UnitsPage extends StatelessWidget {
  UnitsPage({super.key});
  late UnitNotifier _unitNotifier;

  @override
  Widget build(BuildContext context) {
    _unitNotifier = Provider.of<UnitNotifier>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: Text(_unitNotifier.currentKnowledge!.knowledgeName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                Text(
                    "Size: ${_unitNotifier.currentKnowledge!.totalSize} bytes"),
                const SizedBox(width: 20),
                Text("Units: ${_unitNotifier.currentKnowledge!.numberUnits}"),
                const Expanded(child: ButtonAddNewUnit()),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: UnitListview()),
          ],
        ));
  }
}
