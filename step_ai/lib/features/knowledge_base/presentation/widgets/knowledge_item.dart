import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/units_in_knowledge/notifier/unit_notifier.dart';
import 'package:step_ai/shared/helpers/convert_date_time.dart';
import 'package:step_ai/shared/helpers/convert_size.dart';

import '../../../../shared/styles/colors.dart';

class KnowledgeItem extends StatelessWidget {
  final Knowledge knowledge;
  KnowledgeItem({super.key, required this.knowledge});
  late KnowledgeNotifier knowledgeNotifier;
  late UnitNotifier unitNotifier;

  @override
  Widget build(BuildContext context) {
    knowledgeNotifier = Provider.of<KnowledgeNotifier>(context, listen: false);
    unitNotifier = Provider.of<UnitNotifier>(context, listen: false);
    return GestureDetector(
      onTap: () {
        unitNotifier.currentKnowledge = knowledge;
        knowledgeNotifier.reset();
        Navigator.pushNamed(
          context,
          Routes.unitsPage,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.storage, color: TColor.tamarama, size: 38),
            const SizedBox(width: 14),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                      "${ConvertSize.bytesToSize(knowledge.totalSize)}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Update at: ${ConvertDateTime.convertDateTime(knowledge.updatedAt)}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
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
                          backgroundColor: Colors.white,
                          title: Text('Delete Knowledge',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: TColor.poppySurprise)),
                          content: Text(
                            'Are you sure you want to delete "${knowledge.knowledgeName}"?',
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
                                    style: TextStyle(color: Colors.white)),
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
                                    await knowledgeNotifier
                                        .deleteKnowledge(knowledge.id);
                                    await knowledgeNotifier.getKnowledgeList();
                                  } catch (e) {
                                    scaffoldContext.showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: TColor.poppySurprise),
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
                icon: Icon(Icons.delete, color: TColor.petRock)),
          ],
        ),
      ),
    );
  }
}
