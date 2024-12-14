import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/button_add_new_unit.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/edit_knowledge_dialog.dart';
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (_unitNotifier.numberLoadingItemSwitchCounter != 0)
                ? null
                : () {
                    Navigator.pop(context);
                  },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: (_unitNotifier.numberLoadingItemSwitchCounter != 0)
                  ? null
                  : () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const EditKnowledgeDialog();
                          });
                    },
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
                Expanded(child: ButtonAddNewUnit()),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: UnitListview()),
          ],
        ));
  }
}
