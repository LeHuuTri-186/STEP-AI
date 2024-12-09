import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';

class KnowledgeItem extends StatelessWidget {
  final Knowledge knowledge;
  KnowledgeItem({super.key, required this.knowledge});
  late KnowledgeNotifier knowledgeNotifier;
  late UnitNotifier unitNotifier;

  @override
  Widget build(BuildContext context) {
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.storage, color: Colors.blueAccent, size: 38),
          const SizedBox(width: 14),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onTap: () {
                  unitNotifier.currentKnowledge = knowledge;
                  Navigator.pushNamed(
                    context,
                    Routes.unitsPage,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      knowledge.knowledgeName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${knowledge.numberUnits} "
                      "${knowledge.numberUnits > 1 ? 'units' : 'unit'} "
                      "- ${knowledge.totalSize} "
                      "${knowledge.totalSize > 1 ? 'bytes' : 'byte'}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      knowledge.updatedAt.toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Knowledge'),
                        content: Text(
                            'Are you sure you want to delete "${knowledge.knowledgeName}"?'),
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
                              await knowledgeNotifier
                                  .deleteKnowledge(knowledge.id);
                              await knowledgeNotifier.getKnowledgeList();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete, color: Colors.red)),
        ],
      ),
    );
  }
}
