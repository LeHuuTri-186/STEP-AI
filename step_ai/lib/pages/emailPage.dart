import 'package:flutter/material.dart';
import 'package:step_ai/components/dropDownAI.dart';
import 'package:step_ai/components/emailOptions.dart';
import 'package:step_ai/components/messageTile.dart';

import '../components/chatBar.dart';
import '../components/emailOptionTile.dart';
import '../components/historyDrawer.dart';

class EmailPage extends StatefulWidget {

  EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<MessageTile> messages = [
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
      appBar: AppBar(
        title: const Text(
          'Email Step AI',
          style: TextStyle(fontSize: 25,color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
              //EmailOptionTile(icon: Icons.abc_sharp,label: "ABC",onTap: (){},)

              //EmailOptions(),
              // ChatBar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmailOptions(),
                  const SizedBox(height: 5),
                  // ChatBar(),
                  // DropdownAI(),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ChatBar(onSendMessage:onSendMessage ,),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(flex:1,child: DropdownAI()),
                      
                    ],
                  )
                ],
              ),
            
            ],
          )),
    );
  }
}
