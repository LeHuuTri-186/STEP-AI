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
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';
import 'package:step_ai/shared/widgets/app_name_widget.dart';
import 'package:step_ai/features/personal/presentation/widgets/search_bar_widget.dart';
import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_list.dart';
import 'package:step_ai/shared/widgets/search_bar.dart';

import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/authentication/presentation/pages/email_page.dart';
import '../../features/personal/presentation/pages/personal_page.dart';
import '../styles/colors.dart';

class HistoryDrawer extends StatefulWidget {
  HistoryDrawer({super.key});

  @override
  State<HistoryDrawer> createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  final TextEditingController searchController = TextEditingController();

  final LogoutUseCase _logoutUseCase = getIt<LogoutUseCase>();

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
        Provider.of<HistoryConversationListNotifier>(context, listen: false)
            .getHistoryConversationList();
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
    return SafeArea(
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10),),
        ),
        backgroundColor: TColor.northEastSnow.withOpacity(0.7),
        child: Column(
          children: [
            //Logo and App Name
            Container(
              margin: const EdgeInsets.only(right: 10, top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                    offset: const Offset(-3, 3),
                    color: TColor.slate.withOpacity(0.5),
                    blurRadius: 3.0)],
                border: const Border(
                  bottom: BorderSide.none, // Remove the line
                ),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColor.tamarama,
                      TColor.daJuice,
                    ],
                    stops: const [
                      0.2,
                      1,
                    ],
                    tileMode: TileMode.mirror),
              ),
              child: Column(
                children: [
                  Center(child: AppNameWidget()),
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
                boxShadow: [BoxShadow(
                offset: const Offset(-3, 3),
                color: TColor.slate.withOpacity(0.5),
                blurRadius: 3.0)],
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PersonalPage()));
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Personal",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                        color: TColor.petRock,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PlanPricingPage()));
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Plan pricing",
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
                    boxShadow: [BoxShadow(
                        offset: const Offset(-3, 3),
                        color: TColor.slate.withOpacity(0.5),
                        blurRadius: 3.0)],
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
                      'HISTORY',
                      style: GoogleFonts.aBeeZee(
                          color: TColor.royalBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 25),
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
                            leading: Icon(Icons.access_time, color: TColor.petRock.withOpacity(0.5),),
                              title: Text(
                                  "${historyConversationListNotifier.historyConversationList[index].title}", style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: TColor.petRock.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800
                                ),),
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
                                //set id current conversation
                                Provider.of<ChatNotifier>(context, listen: false)
                                        .idCurrentConversation =
                                    historyConversationListNotifier
                                        .historyConversationList[index].id;
                      
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  Routes.chat,
                                  (Route<dynamic> route) => false,
                                );
                              });
                        }, separatorBuilder: (BuildContext context, int index) {
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
                  boxShadow: [BoxShadow(
                      offset: const Offset(-3, 3),
                      color: TColor.slate.withOpacity(0.5),
                      blurRadius: 3.0)],
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
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.authenticate);
                      } catch (e) {
                        print(e);
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
