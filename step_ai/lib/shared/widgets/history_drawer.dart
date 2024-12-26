// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/features/chat/notifier/personal_assistant_notifier.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/app_name_widget.dart';
import 'package:step_ai/features/plan/presentation/pages/plan_pricing_page.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';
import '../../features/personal/presentation/pages/playground_page.dart';
import '../styles/colors.dart';

class HistoryDrawer extends StatefulWidget {
  HistoryDrawer({super.key});

  @override
  State<HistoryDrawer> createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  final TextEditingController searchController = TextEditingController();

  final LogoutUseCase _logoutUseCase = getIt<LogoutUseCase>();
  final PersonalAssistantNotifier _personalAssistantNotifier
      = getIt<PersonalAssistantNotifier>();
  final ChatNotifier _chatNotifier = getIt<ChatNotifier>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Lắng nghe sự kiện cuộn
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          Provider.of<HistoryConversationListNotifier>(context, listen: false)
              .hasMore) {
        //print("Scroll to bottom");
        try {
          Provider.of<HistoryConversationListNotifier>(context, listen: false)
              .getHistoryConversationList();
        } catch (e) {
          //print(e);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyConversationListNotifier =
        Provider.of<HistoryConversationListNotifier>(context);
    FocusScope.of(context).requestScopeFocus();
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            //Logo and App Name
            Container(
              margin: const EdgeInsets.only(right: 10, top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(-3, 3),
                      color: TColor.slate.withOpacity(0.5),
                      blurRadius: 3.0)
                ],
                border: const Border(
                  bottom: BorderSide.none, // Remove the line
                ),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: TColor.tamarama,
              ),
              child: Column(
                children: [
                  Center(
                      child: AppNameWidget(
                    name: 'lib/core/assets/imgs/step-ai-logo-white.png',
                  )),
                  VSpacing.sm,
                  // Search Bar
                  CustomSearchBar(onChanged: (_) {}),
                ],
              ),
            ),

            // Expanded List
            // View for Bots and Histories
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              decoration: BoxDecoration(
                color: TColor.doctorWhite,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(-3, 3),
                      color: TColor.slate.withOpacity(0.5),
                      blurRadius: 3.0)
                ],
                border: const Border(
                  bottom: BorderSide.none, // Remove the line
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10)),
                                  splashColor: TColor.petRock.withOpacity(0.3),
                                  onTap: () {
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.chat,
                                          (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Chat",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                            color: TColor.petRock,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: TColor.petRock.withOpacity(0.3),
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.personal,
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Personal",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            color: TColor.petRock,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10)),
                                splashColor: TColor.petRock.withOpacity(0.3),
                                onTap: () {
                                  if (context.mounted) {
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.planAndPricing,
                                          (Route<dynamic> route) => false,
                                    );
                                  }
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Plan & pricing",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                              color: TColor.petRock,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          VSpacing.sm,
                        ],
                      ),
                    ],
                  ),
                  // List of BOTs
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: TColor.doctorWhite,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(-3, 3),
                          color: TColor.slate.withOpacity(0.5),
                          blurRadius: 3.0)
                    ],
                    border: const Border(
                      bottom: BorderSide.none, // Remove the line
                    ),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                child: Column(
                  children: [
                    Text(
                      'History',
                      style: GoogleFonts.aBeeZee(
                          color: TColor.petRock,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: historyConversationListNotifier
                                .historyConversationList.length +
                            (historyConversationListNotifier.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index ==
                                  historyConversationListNotifier
                                      .historyConversationList.length &&
                              historyConversationListNotifier.hasMore) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: LoadingAnimationWidget.twistingDots(
                                  size: 50,
                                  leftDotColor: TColor.tamarama,
                                  rightDotColor: TColor.daJuice,
                                ),
                              ),
                            );
                          }
                          return ListTile(
                              leading: Icon(
                                Icons.access_time,
                                color: TColor.petRock.withOpacity(0.5),
                              ),
                              title: Text(
                                "${historyConversationListNotifier.historyConversationList[index].title}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: TColor.petRock.withOpacity(0.5),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
                              ),
                              onTap: () async {
                                if (Provider.of<ChatNotifier>(context,
                                            listen: false)
                                        .idCurrentConversation ==
                                    historyConversationListNotifier
                                        .historyConversationList[index].id) {
                                  Navigator.pop(context);
                                  return;
                                }

                                await Provider.of<ChatNotifier>(context,
                                        listen: false)
                                    .resetChatNotifier();
                                if (context.mounted) {
                                  Provider.of<ChatNotifier>(context,
                                              listen: false)
                                          .idCurrentConversation =
                                      historyConversationListNotifier
                                          .historyConversationList[index].id;
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    Routes.chat,
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Divider(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: TColor.doctorWhite,
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(-3, 3),
                        color: TColor.slate.withOpacity(0.5),
                        blurRadius: 3.0)
                  ],
                  border: const Border(
                    bottom: BorderSide.none, // Remove the line
                  ),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              margin: const EdgeInsets.only(bottom: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      try {
                        _logoutUseCase.call(params: null);
                        _personalAssistantNotifier.reset();
                        _chatNotifier.reset();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                            Routes.authenticate,
                                (Route<dynamic> route) => false
                        );
                      } catch (e) {
                        //print(e);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            color: TColor.poppySurprise,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Log out",
                            style: GoogleFonts.aBeeZee(
                                color: TColor.poppySurprise,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
