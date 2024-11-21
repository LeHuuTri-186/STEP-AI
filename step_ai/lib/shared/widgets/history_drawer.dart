import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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

class HistoryDrawer extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final LogoutUseCase _logoutUseCase = getIt<LogoutUseCase>();

  HistoryDrawer({super.key});

  void onSearchTextChanged() {}

  @override
  Widget build(BuildContext context) {
    final historyConversationListNotifier =
        Provider.of<HistoryConversationListNotifier>(context);
    return Drawer(
      backgroundColor: TColor.doctorWhite,
        child: Column(children: [
      //Logo and App Name
      DrawerHeader(
        decoration: BoxDecoration(
          color: TColor.snorlax,
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.deblur,
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(width: 10),
                AppNameWidget(),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            // Search Bar
            CustomSearchBar(onChanged: (_) {}),
          ],
        ),
      ),

      // Expanded ListView for Bots and Histories
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  VSpacing.md,
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PersonalPage()));
                        },
                        child: Text("Personal",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                      )),
                    ],
                  ),
                  VSpacing.sm,
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlanPricingPage()));
                        },
                        child: Text(
                          "Plan pricing",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )),
                    ],
                  ),
                  VSpacing.sm,
                ],
              ),
              // List of BOTs
              ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.center,
                expandedAlignment: Alignment.center,
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.robot,
                      color: Colors.black,
                    ),
                    HSpacing.md,
                    Text(
                      "BOTs",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                children: <Widget>[
                  ListTile(
                      title: Text('Math BOT',
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.black,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage(
                                    chatName: "Math BOT",
                                  )),
                        );
                      }),
                  ListTile(
                      title: Text('English BOT',
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.black,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage(
                                    chatName: "English BOT",
                                  )),
                        );
                      }),
                  ListTile(
                      title: Text('Email BOT',
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.black,
                          )),
                      onTap: () {
                        // Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const EmailPage()),
                        // );
                      }),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(),
              ),
              // Histories
              Text(
                'Histories',
                style: GoogleFonts.jetBrainsMono(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: historyConversationListNotifier
                      .historyConversationList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: TColor.petRock.withOpacity(0.6),
                        ),
                        title: Text(
                            "${historyConversationListNotifier.historyConversationList[index].title}", style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: TColor.petRock.withOpacity(0.6)
                          ),),
                        onTap: () async {
                          if (Provider.of<ChatNotifier>(context, listen: false)
                                  .idCurrentConversation ==
                              historyConversationListNotifier
                                  .historyConversationList[index].id) {
                            Navigator.pop(context);
                            return;
                          }
                
                          await Provider.of<ChatNotifier>(context, listen: false)
                              .resetChatNotifier();
                          //set id current conversation
                          Provider.of<ChatNotifier>(context, listen: false)
                                  .idCurrentConversation =
                              historyConversationListNotifier
                                  .historyConversationList[index].id;
                
                          //update detail conversation in here
                
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.chat,
                            (Route<dynamic> route) => false,
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      Row(
        children: [
          Expanded(
              child: TextButton(
            onPressed: () {
              try {
                _logoutUseCase.call(params: null);
                Navigator.of(context).pushReplacementNamed(Routes.authenticate);
              } catch (e) {
                print(e);
              }
            },
            style: ButtonStyle(
                shape: WidgetStateProperty.resolveWith(
                    (states) => ContinuousRectangleBorder()),
                overlayColor: WidgetStateProperty.resolveWith(
                    (states) => Colors.blue.withOpacity(0.5)),
                surfaceTintColor: WidgetStatePropertyAll(Colors.blueAccent)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Log out",
                    style: GoogleFonts.jetBrainsMono(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          )),
        ],
      )
    ]));
  }
}
