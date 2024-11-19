import 'dart:async';

import 'package:flutter/material.dart';
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
    if (_promptListOverlay.mounted){
      _promptListOverlay.remove();
    }

  }
  final List<Map<String, String>> _aiModels = [
    {
      'name': 'Gemini 1.5 Flash',
      'logo': 'lib/core/assets/imgs/gemini.png'
    },
    {'name': 'Chat GPT 4o', 'logo': 'lib/core/assets/imgs/gpt.png'},
  ];
  String _currentModelPathLogo = "lib/core/assets/imgs/gpt.png";

  void onSendMessage(String sendMessage) {
    setState(() {
      messages.add(MessageTile(
          isAI: false, message: sendMessage));
      messages.add(MessageTile(isAI: true, message: "OK",logoAI: _currentModelPathLogo ));
    });
  }

  @override
  Widget build(BuildContext context) {
    _chatBarNotifier = Provider.of<ChatBarNotifier>(context);
    _promptListNotifier = Provider.of<PromptListNotifier>(context);

    WidgetsBinding.instance.addPostFrameCallback((_){
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
        Navigator.of(context).pushReplacementNamed(Routes.authenticate);
      }

      //Prompt trigger:--------------

    });
    return Scaffold(
      drawer: HistoryDrawer(),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.chatName ?? "Chat", style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05),),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        child: DropdownAI(
                            aiModels: _aiModels, onChange: (nameModel) {
                          _currentModelPathLogo = _aiModels.firstWhere((
                              element) =>
                          element['name'] == nameModel)['logo']!;
                        }),
                      )
                  ),
                  const SizedBox(height: 8),
                  ChatBar(onSendMessage: onSendMessage),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          )),
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
