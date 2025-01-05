import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/domain/entity/assistant.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/preview/domain/entity/kb_in_bot.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/widgets/added_kb_bottom_sheet.dart';
import 'package:step_ai/features/preview/presentation/widgets/preview_chat_bar.dart';
import 'package:step_ai/features/publish/presentation/pages/publish_page.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

import '../../../../shared/widgets/history_drawer.dart';

import '../../../../shared/styles/colors.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _previewChatNotifier = Provider.of<PreviewChatNotifier>(context, listen: false);
      assistant = _previewChatNotifier.currentAssistant!;
      await _previewChatNotifier.loadHistoryMessage(assistant.id!);
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
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: TColor.doctorWhite,
        //Button knowledge_base here
        actions: [
          // IconButton(
          //     onPressed: () async{
          //       await _previewChatNotifier.createThread(
          //         _previewChatNotifier.currentAssistant!.id!
          //       );
          //       _previewChatNotifier.clearHistoryMessages();
          //     },
          //     icon: const Icon(Icons.add)
          // ),

          IconButton(
              onPressed: () async {
                //Knowledge_base linking
                KbListInBot? kbs = await _previewChatNotifier.getKbInBot();
                if (!_previewChatNotifier.isLoading) {
                  showModalBottomSheet(
                    backgroundColor: TColor.doctorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const AddedKbBottomSheet());
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
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const PublishPage()
                    )
                );
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
                    ? Expanded(
                  child: Center(
                    child: _buildProgressIndicator(),
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
                    SizedBox(height: 2),
                    PreviewChatBar(),
                    SizedBox(height: 2),
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
