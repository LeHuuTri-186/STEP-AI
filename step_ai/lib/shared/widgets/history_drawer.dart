import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/routes/routes.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:step_ai/features/chat/notifier/chat_notifier.dart';
import 'package:step_ai/features/chat/notifier/history_conversation_list_notifier.dart';
import 'package:step_ai/shared/widgets/app_name_widget.dart';
import 'package:step_ai/features/personal/presentation/widgets/search_bar_widget.dart';
import 'package:step_ai/features/plan/presentation/pages/planPricingPage.dart';
import 'package:step_ai/features/prompt/presentation/pages/prompt_list.dart';

import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/authentication/presentation/pages/email_page.dart';
import '../../features/personal/presentation/pages/personal_page.dart';

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
        child: Column(children: [
      //Logo and App Name
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
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
            Expanded(
              child: SearchBarWidget(
                onSearch: (searchValue) {},
                backgroundColor: Colors.white,
                hasBorder: false,
              ),
            ),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text('Account'),
                      onTap: () {},
                    ),
                  ),
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
                        style: ButtonStyle(
                            shape: WidgetStateProperty.resolveWith(
                                (states) => ContinuousRectangleBorder()),
                            overlayColor: WidgetStateProperty.resolveWith(
                                (states) => Colors.blue.withOpacity(0.5)),
                            surfaceTintColor:
                                WidgetStatePropertyAll(Colors.blueAccent)),
                        child: Text(
                          "Personal",
                          style: GoogleFonts.jetBrainsMono(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                        style: ButtonStyle(
                            shape: WidgetStateProperty.resolveWith(
                                (states) => ContinuousRectangleBorder()),
                            overlayColor: WidgetStateProperty.resolveWith(
                                (states) => Colors.blue.withOpacity(0.5)),
                            surfaceTintColor:
                                WidgetStatePropertyAll(Colors.blueAccent)),
                        child: Text(
                          "Plan Pricing",
                          style: GoogleFonts.jetBrainsMono(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PromptApp()));
                        },
                        style: ButtonStyle(
                            shape: WidgetStateProperty.resolveWith(
                                (states) => ContinuousRectangleBorder()),
                            overlayColor: WidgetStateProperty.resolveWith(
                                (states) => Colors.blue.withOpacity(0.5)),
                            surfaceTintColor:
                                WidgetStatePropertyAll(Colors.blueAccent)),
                        child: Text(
                          "Prompts",
                          style: GoogleFonts.jetBrainsMono(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              // List of BOTs
              ExpansionTile(
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
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'BOTs',
                      style: GoogleFonts.jetBrainsMono(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
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

              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(),
              ),
              // Histories
              Text(
                'Histories',
                style: GoogleFonts.jetBrainsMono(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: historyConversationListNotifier
                    .historyConversationList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                          "${historyConversationListNotifier.historyConversationList[index].title}"),
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
