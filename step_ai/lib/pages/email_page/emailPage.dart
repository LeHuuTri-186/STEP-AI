import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/components/dropDownAI.dart';
import 'package:step_ai/components/emailOptions.dart';
import 'package:step_ai/components/messageTile.dart';

import '../../components/chatBar.dart';

class EmailPage extends StatefulWidget {

  const EmailPage({super.key});

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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Email Generator", style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.width * 0.05),),
          ],
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ChatBar(onSendMessage:onSendMessage ,),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(flex:1,child: DropdownAI()),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            
            ],
          )),
    );
  }
}
