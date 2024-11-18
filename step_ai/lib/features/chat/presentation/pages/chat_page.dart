import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/shared/widgets/chat_bar.dart';
import 'package:step_ai/shared/widgets/dropdown_Ai.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

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
    _chatNotifier = Provider.of<ChatNotifier>(context,listen: true);
    final messages= _chatNotifier.historyMessages;

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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.chatName ?? "Chat",
              style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageTile(currentMessage: messages[index]);
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: DropdownAI(),
                      )),
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
    );
  }
}
