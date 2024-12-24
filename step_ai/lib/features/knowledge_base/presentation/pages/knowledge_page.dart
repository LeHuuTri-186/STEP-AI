import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/knowledge_base/notifier/knowledge_notifier.dart';
import 'package:step_ai/features/knowledge_base/presentation/widgets/button_add_new_knowledge.dart';
import 'package:step_ai/features/knowledge_base/presentation/widgets/knowledge_listview.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';

class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    KnowledgeNotifier knowledgeNotifier =
        Provider.of<KnowledgeNotifier>(context, listen: true);
    if (knowledgeNotifier.taskStatus == TaskStatus.UNAUTHORIZED) {
      knowledgeNotifier.taskStatus = TaskStatus.OK;
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.authenticate,
        (Route<dynamic> route) => false,
      );
    }

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        //Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: CustomSearchBar(
                      onChanged: (value) => {
                            knowledgeNotifier
                                .changeDisplayKnowledgeWhenSearching(value)
                          })),
            ],
          ),
        ),

        //Button add knowledge
        const ButtonAddNewKnowledge(),

        //Knowledge list view
        Expanded(
          child: KnowledgeListview(),
        ),
      ],
    );
  }
}
