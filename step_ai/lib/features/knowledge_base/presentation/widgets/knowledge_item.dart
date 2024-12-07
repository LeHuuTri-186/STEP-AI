import 'package:flutter/material.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge.dart';

class KnowledgeItem extends StatelessWidget {
  final Knowledge knowledge;
  const KnowledgeItem({super.key, required this.knowledge});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(width: 8),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete, color: Colors.red)),
        ],
      ),
    );
  }
}
