import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

import '../../../../shared/widgets/chat_bar.dart';
import '../../../../shared/widgets/history_drawer.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/shared/widgets/dropdown_ai.dart';
import 'package:step_ai/shared/widgets/image_by_text_widget.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/use_prompt_bottom_sheet.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatName = "Chat"});
  final String? chatName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBarNotifier _chatBarNotifier;
  late PromptListNotifier _promptListNotifier;
  late OverlayEntry _promptListOverlay;
  List<MessageTile> messages = [];
  late ChatNotifier _chatNotifier;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    if (_promptListOverlay.mounted) {
      _promptListOverlay.remove();
    }
  }

  @override
  void initState() {
    super.initState();
    _initOverlay(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
      if (chatNotifier.idCurrentConversation != null) {
        chatNotifier.getMessagesByConversationId();
      }
    });
  }

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
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);
    _promptListNotifier = Provider.of<PromptListNotifier>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Overlay insert:--------
      OverlayState o = Overlay.of(context);
      if (_chatBarNotifier.showOverlay) {
        if (!_promptListOverlay.mounted) {
          o.insert(_promptListOverlay);
        }
        _chatBarNotifier.cancelPrompt();
      } else {
        if (_promptListOverlay.mounted) {
          _promptListOverlay.remove();
        }
      }

      //OverlayEntry rebuild:--------
      if (_promptListNotifier.needRebuildCounter > 0) {
        _promptListOverlay.markNeedsBuild();
      }

      //Logout listener:-------------
      if (_chatBarNotifier.isUnauthorized) {
        _chatBarNotifier.reset();
        _promptListNotifier.reset();
        Navigator.of(context).pushReplacementNamed(Routes.authenticate);
        // _promptListOverlay.remove();
        await _chatBarNotifier.callLogout();
      }

      //Prompt trigger:--------------
    });
    final messages =
        Provider.of<ChatNotifier>(context, listen: true).historyMessages;
    _chatNotifier = Provider.of<ChatNotifier>(context, listen: false);

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
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _chatNotifier.getTitleCurrentConversation(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: TColor.petRock,
                      fontSize: 25,
                    ),
              ),
            ],
          ),
        ),
        backgroundColor: TColor.doctorWhite,
        actions: [
          IconButton(
              onPressed: () async {
                await _chatNotifier.resetChatNotifier();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.chat,
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(
                Icons.add,
                color: TColor.petRock,
              )),
        ],
        iconTheme: IconThemeData(color: TColor.petRock),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //Messages or Loading
                _chatNotifier.isLoadingDetailedConversation
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child:
                                  MessageTile(currentMessage: messages[index]),
                            );
                          },
                        ),
                      ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: DropdownAI(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    ChatBar(
                      onSendMessage: _promptListNotifier.isChangingKey,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ImageByText(
                                imagePath: "lib/core/assets/imgs/flame.png",
                                text:
                                    _chatNotifier.numberRestToken.toString())),
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _initOverlay(BuildContext context) {
    _promptListOverlay = OverlayEntry(builder: (context) {
      return _buildOverlayWidget();
    });
  }

  Widget _buildOverlayWidget() {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
              bottom: MediaQuery.of(context).size.width * 0.5,
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Material(
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(
                            blurRadius: 4,
                            color: TColor.petRock.withOpacity(0.5),
                          )],
                          borderRadius: BorderRadius.circular(10),
                          color: TColor.doctorWhite,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Prompt List'),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (_promptListOverlay.mounted) {
                                          _chatBarNotifier.setShowOverlay(false);
                                          _promptListOverlay.remove();
                                        }
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              _promptListNotifier.isFetching
                                  ? _buildProgressIndicator()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          _promptListNotifier.list.prompts.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            _promptListNotifier
                                                .list.prompts[index].title,
                                            style: TextStyle(
                                                color: TColor.petRock),
                                          ),
                                          onTap: () async {
                                            _chatBarNotifier.setShowOverlay(false);
                                            await _buildUsePrompt(context, _chatNotifier, PromptModel.fromSlash(_promptListNotifier
                                                .list.prompts[index]), index);
                                            // _chatBarNotifier.setContent(
                                            //     _promptListNotifier
                                            //         .list.prompts[index].content);
                                          },
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ))),
              ))
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 200,
        child: Center(
          child: LoadingAnimationWidget.twistingDots(
            size: 50,
            leftDotColor: TColor.tamarama,
            rightDotColor: TColor.daJuice,
          ),
        ),
      ),
    );
  }

  Future<void> _buildUsePrompt(BuildContext context, ChatNotifier notifier,
      PromptModel prompt, int index) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return PromptEditor(
          promptModel: prompt,
          returnPrompt: (value) async {
            await notifier.sendMessage(value);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }
}
