
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_list_panel.dart';
import 'package:step_ai/shared/styles/colors.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';


class AddedKbBottomSheet extends StatefulWidget {
  const AddedKbBottomSheet({super.key});

  @override
  State<AddedKbBottomSheet> createState() => _AddedKbBottomSheetState();
}

class _AddedKbBottomSheetState extends State<AddedKbBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.doctorWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpacing.sm,
              Expanded(
                child: AddedKbPanel(),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final _preview = Provider.of<PreviewChatNotifier>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Knowledge Bases Added", overflow: TextOverflow.ellipsis),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      centerTitle: false,
      actions: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () async {
              KnowledgeList? kl = await _preview.getKnowledgeList() ?? KnowledgeList(knowledgeList: []);
              //Load list kb
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Your Knowledge Bases'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: kl.knowledgeList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(kl.knowledgeList[index].knowledgeName),
                              onTap: () {
                                //Add kl to list.
                                _preview.addKbToBot(kl.knowledgeList[index]);
                                Navigator.pop(
                                    context); // Đóng dialog sau khi chọn
                              },
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Đóng dialog
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  }
              );
            },
            splashColor: TColor.daJuice.withOpacity(0.4),
            highlightColor: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColor.tamarama, // Starting color
                    TColor.daJuice, // Ending color
                  ],
                  begin: Alignment.topLeft, // Gradient starts from top left
                  end: Alignment.bottomRight, // Gradient ends at bottom right
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(Icons.add, color: TColor.doctorWhite),
              ),
            ),
          ),
        ),
        const CloseButton(),
      ],
    );
  }

}
