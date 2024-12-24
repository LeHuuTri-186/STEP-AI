import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/button_add_new_unit.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/edit_knowledge_dialog.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/unit_listview.dart';
import 'package:step_ai/shared/helpers/convert_size.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';

class UnitsPage extends StatelessWidget {
  UnitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _unitNotifier = Provider.of<UnitNotifier>(context, listen: true);
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
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          "Size: ${ConvertSize.bytesToSize(_unitNotifier.currentKnowledge!.totalSize)}"),
                      Text(
                          "Units: ${_unitNotifier.currentKnowledge!.numberUnits}"),
                    ],
                  ),
                ),
                ButtonAddNewUnit(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: CustomSearchBar(
                          onChanged: (value) => {
                                _unitNotifier
                                    .changeDisplayUnitsWhenSearching(value)
                              })),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: UnitListview()),
          ],
        ));
  }
}
