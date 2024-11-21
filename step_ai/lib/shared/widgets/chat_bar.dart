import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/shared/widgets/popup_attachment_options.dart';

import '../../features/prompt/presentation/pages/prompt_bottom_sheet.dart';
import '../styles/colors.dart';

class ChatBar extends StatefulWidget {
  ChatBar({super.key});

  @override
  _ChatBarState createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  bool _showIconSend = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.removeListener(onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  //Event to display/hide the accessibility icons
  void onTextChanged() {
    bool isLoadingResponse = false;
    if ((Provider.of<ChatNotifier>(context, listen: false)
            .historyMessages
            .isNotEmpty &&
        Provider.of<ChatNotifier>(context, listen: false)
                .historyMessages
                .last
                .content ==
            null)) {
      isLoadingResponse = true;
    }
    if (_controller.text.isNotEmpty) {
      if (isLoadingResponse) {
        setState(() {
          _showIconSend = false;
        });
      } else {
        setState(() {
          _showIconSend = true;
        });
      }
    } else {
      setState(() {
        _showIconSend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus(); // Focus when tapped
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: _focusNode.hasFocus
                  ? TColor.doctorWhite
                  : TColor.northEastSnow.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color:
                    _focusNode.hasFocus ? TColor.tamarama : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //TextField to chat
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 3.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: TextField(
                      cursorColor: TColor.squidInk,
                      controller: _controller,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            color: TColor.squidInk,
                          ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        hintText: 'Enter your question',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  color: TColor.petRock.withOpacity(0.5),
                                ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: TColor.doctorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          context: context,
                          builder: (_) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              child: PromptBottomSheet(
                                returnPrompt: (value) async{
                                  _controller.clear();
                                  _controller.text = value;
                                  _controller.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _controller.text.length));
                                  try {
                                    await Provider.of<ChatNotifier>(context,
                                            listen: false)
                                        .sendMessage(_controller.text);
                                  } catch (e) {
                                    //e is 401 and return to login screen
                                    print("e is 401 and return to login screen");
                                    print(e);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      Routes.authenticate,
                                      (Route<dynamic> route) => false,
                                    );
                                  }

                                  _controller.clear();
                                  setState(() {
                                    _showIconSend = true;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        FontAwesomeIcons.wandMagicSparkles,
                        color: TColor.petRock,
                        size: 20,
                      ),
                    ),
                    _showIconSend
                        ? IconButton(
                            padding: const EdgeInsets.all(2),
                            icon: Icon(
                              Icons.send,
                              size: 20,
                              color: TColor.tamarama,
                            ),
                            onPressed: () async {
                              // Hide keyboard
                              FocusScope.of(context).unfocus();
                              try {
                                await Provider.of<ChatNotifier>(context,
                                        listen: false)
                                    .sendMessage(_controller.text);
                              } catch (e) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.authenticate,
                                  (Route<dynamic> route) => false,
                                );
                              }

                              _controller.clear();
                            })
                        : IconButton(
                            padding: const EdgeInsets.all(2),
                            icon: Icon(
                              Icons.send,
                              size: 20,
                              color: TColor.petRock,
                            ),
                            onPressed: () {}),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
