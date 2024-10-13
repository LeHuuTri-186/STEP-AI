import 'package:flutter/material.dart';
import 'package:step_ai/components/dropDownAI.dart';
import 'package:step_ai/components/emailOptions.dart';
import 'package:step_ai/components/messageTile.dart';

import '../components/chatBar.dart';
import '../components/emailOptionTile.dart';
import '../components/historyDrawer.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

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
                  child: ListView(
                children: const [
                  MessageTile(isAI: false, message: "Hello, can you help me?"),
                  //demo for AI icon: deblur
                  MessageTile(
                      iconSendObject: Icons.deblur,
                      isAI: true,
                      message: "Hello, I am Step AI. How can I help you?"),

                  MessageTile(isAI: false, message: "Write an email"),
                  //demo for AI icon: deblur
                  MessageTile(
                      iconSendObject: Icons.deblur,
                      isAI: true,
                      message: """Dear [Recipient's Name],
                            I hope this email finds you well. I am writing to [reason for writing the email].
                            I would like to discuss [topic] and [additional details]. Please let me know if you have any questions or need further information. Thank you for your time and attention. I look forward to hearing from you soon. Sincerely, [Your Name]"""),

                  MessageTile(isAI: false, message: "Summarize"),
                  //demo for AI icon: deblur
                  MessageTile(
                      iconSendObject: Icons.deblur,
                      isAI: true,
                      message:
                          "Dear [Recipient's Name], I am writing to [reason for writing the email]. I would like to discuss [topic] and [additional details]. Please let me know if you have any questions or need further information. Thank you for your time and attention. I look forward to hearing from you soon. Sincerely, [Your Name]"),
                  MessageTile(isAI: false, message: "Detail"),
                  //demo for AI icon: deblur
                  MessageTile(
                      iconSendObject: Icons.deblur, isAI: true, message: """
                      Dear [Recipient's Name],
                      I hope this email finds you well. I am writing to [reason for writing the email]. I would like to discuss [topic] and [additional details]. Please let me know if you have any questions or need further information. Thank you for your time and attention. I look forward to hearing from you soon."""),
                ],
              )),
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
                  const Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ChatBar(),
                      ),
                      SizedBox(width: 10),
                      Expanded(flex:1,child: DropdownAI()),
                      
                    ],
                  )
                ],
              ),
            
            ],
          )),
    );
  }
}
