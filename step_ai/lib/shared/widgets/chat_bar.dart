import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/shared/widgets/popup_attachment_options.dart';

class ChatBar extends StatefulWidget {
  ChatBar({super.key});

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  bool _showIconSend = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  //Event to display/hide the accessibility icons
  void onTextChanged() {
    if (_controller.text.isNotEmpty) {
        setState(() {
          _showIconSend = true;
        });
      } else {
        setState(() {
          _showIconSend = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white54,
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //show the other accessibility icons
          const PopupAttachmentOptions(),

          const SizedBox(width: 4),
          //TextField to chat
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.20,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1, // Add this
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Enter your question',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          //Icon send
          if (_showIconSend)
            IconButton(
                padding: const EdgeInsets.all(2),
                icon: const Icon(
                  Icons.send,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Hide keyboard
                  FocusScope.of(context).unfocus();
                  Provider.of<ChatNotifier>(context,listen: false).sendMessage(_controller.text);
                  _controller.clear();
                })
        ],
      ),
    );
  }
}
