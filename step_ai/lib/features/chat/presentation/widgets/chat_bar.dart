import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';

class ChatBar extends StatefulWidget {
  final Function(String) onSendMessage;
  ChatBar({super.key, required this.onSendMessage});

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  final TextEditingController _controller = TextEditingController();
  late ChatBarNotifier _chatBarNotifier;
  late PromptListNotifier _listNotifier;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(onTextChanged);
    _controller.dispose();

    _debounce?.cancel();
    super.dispose();
  }

  //Event to display/hide the accessibility icons
  void onTextChanged() {
    if (_controller.text.isNotEmpty) {
      if (_chatBarNotifier.showIcons) {
        _chatBarNotifier.setShowIcons(false);
      }
      _chatBarNotifier.setShowIconSend(true);

      if (_controller.text.startsWith('/')){

        if (_debounce?.isActive ?? false){
          _debounce?.cancel();
        }
        _debounce = Timer(const Duration(milliseconds: 800), () async{
          _chatBarNotifier.setShowOverlay(true);
          TaskStatus status = await _listNotifier.getPrompts(_controller.text);
          if (status == TaskStatus.UNAUTHORIZED) {
            _chatBarNotifier.setLogout(true);
          }
        });
      }
      else {
        _chatBarNotifier.setShowOverlay(false);
      }
    } else{
      _chatBarNotifier.setShowIconSend(false);
      _chatBarNotifier.setShowOverlay(false);
    }
  }

  void _toggleIcons() {
    _chatBarNotifier.setShowIcons(!_chatBarNotifier.showIcons);
  }

  @override
  Widget build(BuildContext context) {
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);
    _listNotifier = Provider.of<PromptListNotifier>(context);

    if (_chatBarNotifier.triggeredPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = '';
        _controller.text = _chatBarNotifier.content;
        _chatBarNotifier.cancelPrompt();
      });

    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white54,
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          //show icon "add" to display the other accessibility icons
          if (!_chatBarNotifier.showIcons)
            IconButton(
              padding: const EdgeInsets.all(2),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: _toggleIcons,
            ),
          //show the other accessibility icons
          if (_chatBarNotifier.showIcons) ...[
            //Icon camera
            IconButton(
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            //Icon photo
            IconButton(
              icon: const Icon(
                Icons.photo,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            //Icon file
            IconButton(
              icon: const Icon(
                Icons.attach_file,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {},
            ),

            IconButton(
              icon: const Icon(
                Icons.arrow_left,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _toggleIcons();
                });
              },
            ),
          ],

          const SizedBox(width: 4),
          //TextField to chat
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Enter your question',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 4),
          //Icon send
          if (_chatBarNotifier.showIconSend)
            IconButton(
                padding: const EdgeInsets.all(2),
                icon: const Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () {
                  widget.onSendMessage(_controller.text);
                  _controller.clear();
                  _chatBarNotifier.setShowIconSend(false);
                })
        ],
      ),
    );
  }
}
