import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_bottom_sheet.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_list_panel.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_list_view.dart';
import 'package:step_ai/features/preview/presentation/widgets/preview_chat_bar.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

import '../../../../shared/widgets/chat_bar.dart';
import '../../../../shared/widgets/history_drawer.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/shared/widgets/dropdown_ai.dart';
import 'package:step_ai/shared/widgets/image_by_text_widget.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/use_prompt_bottom_sheet.dart';

class PreviewChatPage extends StatefulWidget {
  const PreviewChatPage({super.key, this.chatName = "Chat"});
  final String? chatName;

  @override
  State<PreviewChatPage> createState() => _PreviewChatPageState();
}

class _PreviewChatPageState extends State<PreviewChatPage> {
  late Assistant assistant;
  late ChatBarNotifier _chatBarNotifier;
  List<MessageTile> messages = [];
  late PreviewChatNotifier _previewChatNotifier;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _previewChatNotifier = Provider.of<PreviewChatNotifier>(context, listen: false);
      assistant = _previewChatNotifier.currentAssistant!;
      if (_previewChatNotifier.currentThread == null) {
        _previewChatNotifier.createThread(assistant.id!);
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 1000),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // //Overlay insert:--------
      // OverlayState o = Overlay.of(context);
      // if (_chatBarNotifier.showOverlay) {
      //   _chatBarNotifier.cancelPrompt();
      // } else {
      //   if (_promptListOverlay.mounted) {
      //     _promptListOverlay.remove();
      //   }
      // }
      //
      // //OverlayEntry rebuild:--------
      // if (_promptListNotifier.needRebuildCounter > 0) {
      //   _promptListOverlay.markNeedsBuild();
      // }

      //Logout listener:-------------
      if (_chatBarNotifier.isUnauthorized) {
        _chatBarNotifier.reset();
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.authenticate, (Route<dynamic> route) => false);

        // _promptListOverlay.remove();
        await _chatBarNotifier.callLogout();
      }

      //Prompt trigger:--------------
    });
    final messages =
        Provider.of<PreviewChatNotifier>(context, listen: true).historyMessages;
    _previewChatNotifier = Provider.of<PreviewChatNotifier>(context, listen: false);

    // Add this to scroll when messages update
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          FocusScope.of(context).unfocus();
        }
      },
      drawer: HistoryDrawer(),
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_previewChatNotifier.currentAssistant!.name!} (Preview)',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: TColor.petRock,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: TColor.doctorWhite,
        //Button knowledge_base here
        actions: [
          IconButton(
              onPressed: () async {
                //Knowledge_base linking
                KbListInBot? kbs = await _previewChatNotifier.getKbInBot();
                if (!_previewChatNotifier.isLoading) {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context){
                        return const AddedKbBottomSheet();
                      });
                }
              },

              icon: Icon(
                Icons.library_books_rounded,
                color: TColor.petRock,
              )),
          IconButton(
              onPressed: () async {
                //Knowledge_base publishing

              },
              icon: Icon(
                Icons.publish,
                color: TColor.petRock,
              )),
        ],
        iconTheme: IconThemeData(color: TColor.petRock),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //Messages or Loading
                _previewChatNotifier.isCreatingThread
                    ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    :
              Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 4.0),
                        child:
                        MessageTile(currentMessage: messages[index]),
                      );
                    },
                  ),
                ),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 4),
                    //Dropdown AI?
                    // const Row(
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(left: 8.0),
                    //       child: DropdownAI(),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 2),
                    PreviewChatBar(),
                    SizedBox(height: 2),
                    // Row(
                    //   children: [
                    //     Padding(
                    //         padding: const EdgeInsets.only(left: 10),
                    //         child: ImageByText(
                    //             imagePath: "lib/core/assets/imgs/flame.png",
                    //             text:
                    //             _previewChatNotifier.numberRestToken.toString())),
                    //   ],
                    // ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void onMessageSent(String s){

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

}
