import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/domain/usecase/get_prompt_list_usecase.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/shared/widgets/dropdown_Ai.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/history_drawer.dart';
import '../widgets/chat_bar.dart';
import 'package:step_ai/features/chat/domain/entity/message.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_bottom_sheet.dart';
import 'package:step_ai/shared/widgets/chat_bar.dart';
import 'package:step_ai/shared/widgets/dropdown_ai.dart';
import 'package:step_ai/shared/widgets/history_drawer.dart';
import 'package:step_ai/shared/widgets/image_by_text_widget.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';

import '../../../../shared/styles/colors.dart';

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initOverlay(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if(_promptListOverlay.mounted){
      _promptListOverlay.remove();
    }

  }
  String _currentModelPathLogo = "lib/core/assets/imgs/gpt.png";
  late ChatNotifier _chatNotifier;
  late List<Message> messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
  //   if (_chatNotifier.idCurrentConversation != null) {
  //     _chatNotifier.getMessagesByConversationId();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);
    _promptListNotifier = Provider.of<PromptListNotifier>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      //Overlay insert:--------
      OverlayState o = Overlay.of(context);
      if (_chatBarNotifier.showOverlay){
        if (!_promptListOverlay.mounted){
          o.insert(_promptListOverlay);
        }
        _chatBarNotifier.cancelPrompt();
      }
      else {
        if (_promptListOverlay.mounted){
          _promptListOverlay.remove();
        }
      }

      //OverlayEntry rebuild:--------
      if (_promptListNotifier.needRebuildCounter>0) {
        _promptListOverlay.markNeedsBuild();
      }

      //Logout listener:-------------
      if(_chatBarNotifier.isUnauthorized) {
        //TODO: Handle logout
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
                      child:  Center(
                          child: CircularProgressIndicator(),
                        ),
                    )
                    : Expanded(
                         child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: MessageTile(currentMessage: messages[index]),
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
                    ChatBar(),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ImageByText(imagePath: "lib/core/assets/imgs/flame.png", text: _chatNotifier.numberRestToken.toString())
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _initOverlay(BuildContext context){
    _promptListOverlay = OverlayEntry(
        builder: (context) {
          return _buildOverlayWidget();
        });
  }

  Widget _buildOverlayWidget(){
    return Stack(
      children: [
        Positioned(
            bottom: 80,
            left: 65,
            right: 18,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
              },
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('Prompt List'),
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (_promptListOverlay.mounted) {
                                        _promptListOverlay.remove();
                                      }
                                    },
                                    icon: const Icon(Icons.close))
                              ],
                            ),
                            _promptListNotifier.isFetching?
                            _buildProgressIndicator():
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: _promptListNotifier.list
                                  .prompts.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    _promptListNotifier
                                        .list
                                        .prompts[index].title,
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    _chatBarNotifier.setContent(
                                      _promptListNotifier.list.prompts[index]
                                          .content
                                    );
                                    _chatBarNotifier.triggerPrompt();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                  )
              ),
            )
        )
      ],
    );
  }

  Widget _buildProgressIndicator(){
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
