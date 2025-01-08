import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/knowledge_base/domain/entity/knowledge_list.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_list_panel.dart';
import 'package:step_ai/shared/styles/colors.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import '../../../../shared/styles/horizontal_spacing.dart';

class AddedKbBottomSheet extends StatefulWidget {
  const AddedKbBottomSheet({super.key});

  @override
  State<AddedKbBottomSheet> createState() => _AddedKbBottomSheetState();
}

class _AddedKbBottomSheetState extends State<AddedKbBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final _preview = Provider.of<PreviewChatNotifier>(context);

    return Container(
      decoration: BoxDecoration(
        color: TColor.doctorWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: !_preview.isLoading
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpacing.sm,
                    Expanded(
                      child: AddedKbPanel(),
                    )
                  ],
                )
              : Center(child: _buildProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 200,
        child: Center(
          child: LoadingAnimationWidget.twistingDots(
            size: 50,
            leftDotColor: TColor.tamarama,
            rightDotColor: TColor.daJuice,
          ),
        ),
      ),
    );
  }

  void showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.doctorWhite,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Oops!",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              CloseButton(
                onPressed: Navigator.of(context).pop,
              )
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(error,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: TColor.petRock,
                      fontWeight: FontWeight.w700,
                    )),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Got it",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: TColor.poppySurprise,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final _preview = Provider.of<PreviewChatNotifier>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Knowledge Bases", overflow: TextOverflow.ellipsis)),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      centerTitle: false,
      actions: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () async {
              KnowledgeList? kl = await _preview.getKnowledgeList() ??
                  KnowledgeList(knowledgeList: []);
              if (kl.knowledgeList.isEmpty && context.mounted) {
                showErrorDialog(context,
                    'Your knowledge base is kind of empty! Add some wisdom first!');
              }

              if (kl.knowledgeList.isNotEmpty && context.mounted) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: TColor.doctorWhite,
                        title: const Text('Your Knowledge Bases'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: kl.knowledgeList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Row(
                                      children: [
                                        const Icon(FontAwesomeIcons.server),
                                        HSpacing.lg,
                                        Text(kl.knowledgeList[index].knowledgeName),
                                      ],
                                    ),
                                onTap: () {

                                  if (_preview.knowledgeList!.knowledgeList.contains(kl.knowledgeList[index])) {
                                    showErrorDialog(context, 'It seems this knowledge base has already been added!');

                                    return;
                                  }

                                  _preview.addKbToBot(kl.knowledgeList[index]);

                                  Navigator.pop(context);
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
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(TColor.petRock),
                            ),
                            child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: TColor.doctorWhite,
                              fontWeight: FontWeight.w600,
                            ),),
                          ),
                        ],
                      );
                    });
              }
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
