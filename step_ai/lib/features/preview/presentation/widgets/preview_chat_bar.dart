import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/preview/presentation/notifier/preview_chat_notifier.dart';
import 'package:step_ai/shared/styles/colors.dart';
import 'package:step_ai/shared/widgets/popup_attachment_options.dart';


class PreviewChatBar extends StatefulWidget {
  const PreviewChatBar({super.key});

  @override
  _PreviewChatBarState createState() => _PreviewChatBarState();
}

class _PreviewChatBarState extends State<PreviewChatBar> {
  bool _showIconSend = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ChatBarNotifier _chatBarNotifier;
  late PersonalAssistantNotifier _personalAssistantNotifier;
  late PreviewChatNotifier _previewChatNotifier;

  Timer? _debounce;

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
    _debounce?.cancel();
    super.dispose();
  }

  //Event to display/hide the accessibility icons
  void onTextChanged() {
    final currentText = _controller.text;

    // If the text is empty, reset relevant states and return
    if (currentText.isEmpty) {
      _chatBarNotifier.setShowOverlay(false);
      setState(() {
        _showIconSend = false;
      });
      _debounce?.cancel(); // Cancel any pending debounce timer
      return;
    }

    // // Determine if a response is loading
    // final previewChatNotifier =
    //       Provider.of<PreviewChatNotifier>(context, listen: false);
    // final isLoadingResponse = previewChatNotifier.historyMessages.isNotEmpty &&
    //     previewChatNotifier.historyMessages.last.content == null;

    // // Update the state of the send icon
    // setState(() {
    //   _showIconSend = !isLoadingResponse && !currentText.startsWith('/');
    // });
    //
    // // Handle command input if the text starts with "/"
    // if (currentText.startsWith('/')) {
    //   _debounce?.cancel(); // Cancel any previous debounce
    //   _debounce = Timer(const Duration(milliseconds: 800), () async {
    //     _chatBarNotifier.setShowOverlay(true);
    //     final status = await _listNotifier.getPrompts(currentText);
    //
    //     // Handle unauthorized status if detected
    //     if (status == TaskStatus.UNAUTHORIZED) {
    //       _chatBarNotifier.setLogout(true);
    //     }
    //   });
    // } else {
    //   // If not a command, hide the overlay
    //   _chatBarNotifier.setShowOverlay(false);
    // }
  }


  @override
  Widget build(BuildContext context) {
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);
    _personalAssistantNotifier = Provider.of<PersonalAssistantNotifier>(context);
    _previewChatNotifier = Provider.of<PreviewChatNotifier>(context);

    // if (_chatBarNotifier.triggeredPrompt) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _controller.text = '';
    //     _controller.text = _chatBarNotifier.content;
    //     _chatBarNotifier.cancelPrompt();
    //   });
    //
    // }
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
                      autocorrect: false,
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
                        hintText: 'Enter your question to the assistant.',
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

                    //Button for prompt

                    // IconButton(
                    //   onPressed: () {
                    //     _chatBarNotifier.setShowOverlay(false);
                    //     showModalBottomSheet(
                    //       backgroundColor: TColor.doctorWhite,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       context: context,
                    //       builder: (_) {
                    //         return ClipRRect(
                    //           borderRadius: const BorderRadius.only(
                    //             topLeft: Radius.circular(30),
                    //             topRight: Radius.circular(30),
                    //           ),
                    //           child: PromptBottomSheet(
                    //             returnPrompt: (value) async {
                    //               _controller.clear();
                    //               try {
                    //                 if (_personalAssistantNotifier.isPersonal) {
                    //                   await Provider.of<ChatNotifier>(
                    //                       context, listen: false
                    //                   ).sendMessageForPersonalBot(value);
                    //                 }
                    //                 else {
                    //                   await Provider.of<ChatNotifier>(
                    //                       context, listen: false
                    //                   ).sendMessage(value);
                    //                 }
                    //               } catch (e) {
                    //                 //e is 401 and return to login screen
                    //                 print(
                    //                     "e is 401 and return to login screen");
                    //                 print(e);
                    //
                    //                 Navigator.of(context)
                    //                     .pushNamedAndRemoveUntil(
                    //                   Routes.authenticate,
                    //                       (Route<dynamic> route) => false,
                    //                 );
                    //               }
                    //             },
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    //   icon: Icon(
                    //     FontAwesomeIcons.wandMagicSparkles,
                    //     color: TColor.petRock,
                    //     size: 20,
                    //   ),
                    // ),

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
                            if (_previewChatNotifier.currentAssistant != null) {
                              //On send:
                              _previewChatNotifier.sendMessageInPreviewMode(
                                _controller.text
                              );
                            }
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
                        onPressed: () {

                        }),
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
