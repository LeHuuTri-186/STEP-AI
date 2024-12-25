import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/custom_cupertino.dart';
import 'package:step_ai/shared/helpers/convert_date_time.dart';
import 'package:step_ai/shared/helpers/convert_size.dart';

class UnitItem extends StatelessWidget {
  final Unit unit;
  UnitItem({super.key, required this.unit});
  late UnitNotifier unitNotifier;
  late KnowledgeNotifier knowledgeNotifier;
  void findAndUpdateCurrentKnowledge() {
    //to update size and numbers units when delete or add unit
    knowledgeNotifier.knowledgeList!.knowledgeList.forEach((knowledge) {
      if (knowledge.id == unitNotifier.currentKnowledge!.id) {
        unitNotifier.updateCurrentKnowledge(knowledge);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          //Icon + size + type source
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Image.asset(
                  unit.metadata.getIconPath(),
                  width: 34,
                  height: 34,
                ),
                const SizedBox(height: 4),
                Text(
                  ConvertSize.bytesToSize(unit.size),
                  style: const TextStyle(fontSize: 8),
                ),
                const SizedBox(height: 4),
                Text(
                  unit.metadata.getTypeName(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          //Name + create + update source
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.name,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Create: ${ConvertDateTime.convertDateTime(unit.createdAt)}",
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                    "Update: ${ConvertDateTime.convertDateTime(unit.updatedAt)}",
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          //Status disable or not + delete
          Expanded(
              flex: 1,
              child: Transform.scale(
                  scale: 0.7, child: CustomCupertino(unit: unit))),
          Expanded(
            flex: 1,
            child: IconButton(
                onPressed: unitNotifier.numberLoadingItemSwitchCounter != 0
                    ? null
                    : () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('Delete Unit',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red)),
                                content: Text(
                                  'Are you sure you want to delete "${unit.name}"?',
                                  textAlign: TextAlign.center,
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey),
                                      child: const Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final scaffoldContext =
                                            ScaffoldMessenger.of(context);
                                        Navigator.of(context).pop();
                                        try {
                                          await unitNotifier
                                              .deleteUnit(unit.id);
                                          await unitNotifier.getUnitList();

                                          unitNotifier.setIsLoading(true);
                                          await knowledgeNotifier
                                              .getKnowledgeList();
                                          findAndUpdateCurrentKnowledge();
                                          unitNotifier.setIsLoading(false);
                                        } catch (e) {
                                          unitNotifier.setIsLoading(false);
                                          scaffoldContext.showSnackBar(SnackBar(
                                            content: Text(
                                              e.toString(),
                                            ),
                                          ));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                icon: const Icon(Icons.delete, color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
