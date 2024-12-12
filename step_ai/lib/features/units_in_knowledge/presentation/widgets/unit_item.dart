import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/domain/entity/unit.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/presentation/widgets/custom_cupertino.dart';

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
                  "${unit.size.toString()} bytes",
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
                  "Create: ${unit.createdAt}",
                  style: const TextStyle(fontSize: 10),
                ),
                Text("Update: ${unit.updatedAt}",
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Unit'),
                          content: Text(
                              'Are you sure you want to delete "${unit.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await unitNotifier.deleteUnit(unit.id);
                                await unitNotifier.getUnitList();

                                unitNotifier.setIsLoading(true);
                                await knowledgeNotifier.getKnowledgeList();
                                findAndUpdateCurrentKnowledge();
                                unitNotifier.setIsLoading(false);
                              },
                              child: const Text('Delete'),
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
