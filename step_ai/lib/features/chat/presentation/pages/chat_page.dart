import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_bottom_sheet.dart';
import 'package:step_ai/shared/widgets/chat_bar.dart';
import 'package:step_ai/shared/widgets/dropdown_Ai.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

import '../../../../shared/styles/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatName = "Chat"});
  final String? chatName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatNotifier _chatNotifier;
  late List<Message> messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
      if (chatNotifier.idCurrentConversation != null) {
        chatNotifier.getMessagesByConversationId();
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
  //   if (_chatNotifier.idCurrentConversation != null) {
  //     _chatNotifier.getMessagesByConversationId();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final messages =
        Provider.of<ChatNotifier>(context, listen: true).historyMessages;
    _chatNotifier = Provider.of<ChatNotifier>(context, listen: false);

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
                _chatNotifier.getTitleCurrentConversation(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: TColor.petRock,
                      fontSize: 25,
                    ),
              ),
            ],
          ),
        ),
        backgroundColor: TColor.doctorWhite,
        actions: [
          IconButton(
              onPressed: () async {
                await _chatNotifier.resetChatNotifier();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.chat,
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(
                Icons.add,
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
                _chatNotifier.isLoadingDetailedConversation
                    ? const Expanded(
                      child:  Center(
                          child: CircularProgressIndicator(),
                        ),
                    )
                    : Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return MessageTile(currentMessage: messages[index]);
                          },
                        ),
                      ),

                //DropdownAI(), and ChatBar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: DropdownAI(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ChatBar(),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Token còn lại: ${_chatNotifier.numberRestToken}",
                        style: GoogleFonts.jetBrainsMono(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.width * 0.03),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
