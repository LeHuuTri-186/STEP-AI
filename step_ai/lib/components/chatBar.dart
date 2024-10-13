import 'package:flutter/material.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({super.key});

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  bool _showIcons = false;
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
    if (_controller.text.isNotEmpty && _showIcons) {
      setState(() {
        _showIcons = false;
      });
    }
  }

  void _toggleIcons() {
    setState(() {
      _showIcons = !_showIcons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[500],
        border: Border.all(
            color: Colors.black87, width: 1), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          //show icon "add" to display the other accessibility icons
          if (!_showIcons)
            IconButton(
              padding: const EdgeInsets.all(2),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: _toggleIcons,
            ),
          //show the other accessibility icons
          if (_showIcons) ...[
            //Icon camera
            IconButton(
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            //Icon photo
            IconButton(
              icon: const Icon(
                Icons.photo,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            //Icon file
            IconButton(
              icon: const Icon(
                Icons.attach_file,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],

          const SizedBox(width: 4),
          //TextField to chat
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter your question',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 4),
          //Icon send
          IconButton(
              padding: const EdgeInsets.all(2),
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
