import 'dart:async';

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/task_status.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/features/chat/presentation/notifier/chat_bar_notifier.dart';
import 'package:step_ai/features/chat/presentation/notifier/prompt_list_notifier.dart';
import 'package:step_ai/features/chat/presentation/widgets/greetings.dart';
import 'package:step_ai/features/prompt/data/models/prompt_model.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/usecases/admod_service.dart';
import 'package:step_ai/shared/usecases/pricing_redirect_service.dart';
import 'package:step_ai/shared/widgets/message_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/styles/vertical_spacing.dart';
import '../../../../shared/widgets/chat_bar.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/history_drawer.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/shared/widgets/dropdown_ai.dart';
import 'package:step_ai/shared/widgets/image_by_text_widget.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/widgets/use_prompt_bottom_sheet.dart';
import '../../../prompt/presentation/pages/prompt_bottom_sheet.dart';

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
  late ScrollController _scrollController;
  BannerAd? _bannerAd;

  @override
  void dispose() {
    if (_promptListOverlay.mounted) {
      _promptListOverlay.remove();
    }
    _scrollController.dispose();

    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _initOverlay(context);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatNotifier = Provider.of<ChatNotifier>(context, listen: false);
      Provider.of<PromptListNotifier>(context, listen: false)
          .loadFeaturedPrompt();
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

              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.chat,
                  (Route<dynamic> route) => false,
                );
              }
            },
            icon: Icon(
              Icons.add,
              color: TColor.petRock,
            ),
          ),
        ],
        iconTheme: IconThemeData(color: TColor.petRock),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (_bannerAd != null && (Platform.isAndroid || Platform.isIOS))
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: AdWidget(
                      ad: _bannerAd!,
                    ),
                  ),
                //Messages or Loading
                _chatNotifier.isLoadingDetailedConversation
                    ? Expanded(
                        child: Center(
                          child: LoadingAnimationWidget.twistingDots(
                            size: 50,
                            leftDotColor: TColor.tamarama,
                            rightDotColor: TColor.daJuice,
                          ),
                        ),
                      )
                    : Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: messages.isNotEmpty
                              ? ListView.builder(
                                  primary: false,
                                  controller: _scrollController,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: MessageTile(
                                          currentMessage: messages[index]),
                                    );
                                  },
                                )
                              : SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Text(
                                              "👋",
                                              style: TextStyle(
                                                fontSize: 40,
                                              ),
                                            ),
                                          ],
                                        ),
                                        VSpacing.sm,
                                        const GreetingMessage(),
                                        VSpacing.sm,
                                        Text(
                                          "I'm STEP, your personal assistant.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.normal),
                                        ),
                                        VSpacing.md,
                                        _buildNewChatPage(),
                                        VSpacing.sm,
                                        if (_promptListNotifier
                                            .displayPrompt.isNotEmpty)
                                          Flex(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                "Don't know what to say? Use a prompt!",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    _buildPromptBottomSheet(
                                                        context);
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      "View all",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: TColor
                                                                .tamarama
                                                                .withOpacity(
                                                                    0.8),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        Column(
                                          children: _promptListNotifier
                                              .displayPrompt
                                              .map((prompt) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    _buildUsePrompt(
                                                        context,
                                                        _chatNotifier,
                                                        PromptModel.fromSlash(
                                                            prompt));
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: TColor
                                                          .northEastSnow
                                                          .withOpacity(0.5),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            prompt.title,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                  color: TColor
                                                                      .petRock,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_circle_right_outlined,
                                                            color:
                                                                TColor.petRock,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),

                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          DropdownAI(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    ChatBar(
                      onSendMessage: _promptListNotifier.isChangingKey,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          ImageByText(
                            imagePath: "lib/core/assets/imgs/flame.png",
                            text: _chatNotifier.numberRestToken.toString(),
                          ),
                          HSpacing.sm,
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async =>
                                  await PricingRedirectService.call(),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.rocket_launch_rounded,
                                      color: TColor.tamarama,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    GradientText(
                                      'Upgrade',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: TColor.tamarama,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        tileMode: TileMode.decal,
                                        colors: [
                                          TColor.tamarama,
                                          TColor.goldenState,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildNewChatPage() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: const Offset(-3, 3),
              color: TColor.slate.withOpacity(0.5),
              blurRadius: 3.0)
        ],
        color: TColor.tamarama,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Text(
              "Upgrade your plan for unlimited access with a one-month free trial!",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: TColor.doctorWhite,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          VSpacing.md,
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(-3, 3),
                    color: TColor.slate.withOpacity(0.5),
                    blurRadius: 3.0)
              ],
              color: TColor.doctorWhite,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Start free trial"),
                HSpacing.sm,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: TColor.tamarama,
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Colors.blueAccent,
                              TColor.tamarama,
                            ]),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          "Subscribe",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: 15,
                                  color: TColor.doctorWhite,
                                  fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _buildPromptBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
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
            returnPrompt: (value) async {
              try {
                await Provider.of<ChatNotifier>(context, listen: false)
                    .sendMessage(value);
              } catch (e) {
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.authenticate,
                    (Route<dynamic> route) => false,
                  );
                }
              }
            },
          ),
        );
      },
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: MediaQuery.of(context).size.width * 0.2,
              right: MediaQuery.of(context).size.width * 0.2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Material(
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: TColor.petRock.withOpacity(0.5),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: TColor.doctorWhite,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Prompt List'),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        if (_promptListOverlay.mounted) {
                                          _chatBarNotifier
                                              .setShowOverlay(false);
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
                                      itemCount: _promptListNotifier
                                          .list.prompts.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            _promptListNotifier
                                                .list.prompts[index].title,
                                            style: TextStyle(
                                                color: TColor.petRock),
                                          ),
                                          onTap: () async {
                                            _chatBarNotifier
                                                .setShowOverlay(false);
                                            await _buildUsePrompt(
                                              context,
                                              _chatNotifier,
                                              PromptModel.fromSlash(
                                                  _promptListNotifier
                                                      .list.prompts[index]),
                                            );
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

  Future<void> _buildUsePrompt(
      BuildContext context, ChatNotifier notifier, PromptModel prompt) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return PromptEditor(
          promptModel: prompt,
          returnPrompt: (value) async {
            try {
              await notifier.sendMessage(value);
            } catch (e) {
              //e is 401 and return to login screen

              print(e);
              if (context.mounted &&
                  e is TaskStatus &&
                  e == TaskStatus.UNAUTHORIZED) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.authenticate,
                  (Route<dynamic> route) => false,
                );
              }
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  void _createBannerAd() {
    if (!kIsWeb) {
      _bannerAd = BannerAd(
          size: AdSize.fullBanner,
          adUnitId: AdModService.getBannerAdUnitId()!,
          listener: AdModService.listener,
          request: const AdRequest())
        ..load();
    }
  }
}
