import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/components/dropDownAI.dart';
import 'package:step_ai/components/messageTile.dart';
import 'package:step_ai/pages/personal_page/personalPage.dart';
import 'package:step_ai/pages/personal_page/widgets/dropdownWidget.dart';

import 'package:step_ai/components/appNameWidget.dart';
import '../../components/chatBar.dart';
import '../../components/historyDrawer.dart';
import '../../utils/routes/routes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatName = "Chat"});
  final String? chatName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageTile> messages = [
    // const MessageTile(isAI: false, message: "Hello, can you help me?"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "Hello, I am Step AI. How can I help you?"),
    // const MessageTile(isAI: false, message: "what is the solar system?"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "The Solar System consists of the Sun, eight planets..."),
    // const MessageTile(isAI: false, message: "Summarize"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "The Solar System includes the Sun, eight planets..."),
    // const MessageTile(isAI: false, message: "Detail"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "Terrestrial planets (rocky planets): Mercury..."),
    // const MessageTile(isAI: false, message: "Detail"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "Terrestrial planets (rocky planets): Mercury..."),
    // const MessageTile(isAI: false, message: "Detail"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "Terrestrial planets (rocky planets): Mercury..."),
    // const MessageTile(isAI: false, message: "Detail"),
    // const MessageTile(
    //     iconSendObject: Icons.deblur,
    //     isAI: true,
    //     message: "Terrestrial planets (rocky planets): Mercury..."),
  ];

  void onSendMessage(String sendMessage) {
    setState(() {
      messages.add(MessageTile(
          isAI: false, message: sendMessage, iconSendObject: Icons.deblur));
      messages.add(const MessageTile(isAI: true, message: "OK"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HistoryDrawer(),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.chatName??"Chat", style: GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: MediaQuery.of(context).size.width * 0.05),),
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
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index];
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
                        child: DropdownWidget(display: "Bots:",types: const ["New bot", "Chat GPT", "Bing", "Llama"], onSelect: (m) {
                          if (m == "New bot") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalPage()));
                          }
                        },)
                    ),
                  ),
                  const SizedBox(height: 8), // Khoảng cách giữa DropdownAI và ChatBar
                  ChatBar(onSendMessage: onSendMessage,),
                  SizedBox(height: 20,),
                ],
              ),
            ],
          )),
    );
  }
}
