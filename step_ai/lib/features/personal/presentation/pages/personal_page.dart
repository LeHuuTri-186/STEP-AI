import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/request_response.dart';
import 'package:step_ai/core/di/service_locator.dart';
import 'package:step_ai/features/personal/data/models/bot_res_dto.dart';
import 'package:step_ai/features/personal/presentation/notifier/bot_list_notifier.dart';
import 'package:step_ai/features/personal/presentation/widgets/bot_list_panel.dart';
import 'package:step_ai/shared/styles/colors.dart';

import 'package:step_ai/features/knowledge_base/presentation/pages/knowledge_page.dart';

import 'package:step_ai/shared/widgets/history_drawer.dart';
import 'package:step_ai/features/personal/presentation/widgets/search_bar_widget.dart';
import 'package:step_ai/features/personal/presentation/widgets/dropdown_widget.dart';

import '../../data/models/bot_model.dart';
import '../widgets/create_bot_dialog.dart';
import '../widgets/no_bot_panel.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late BotListNotifier _botListNotifier;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BotListNotifier>().getBots(null);
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _botListNotifier = Provider.of<BotListNotifier>(context);

    return _botListNotifier.isLoading ? _buildProgressIndicator() :
    Scaffold(
      appBar: _buildAppBar(),
      drawer: HistoryDrawer(),
      body: Column(
        children: [
          TabBar(
              indicatorColor: Colors.blue[400],
              labelStyle:
              GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800),
              controller: _tabController,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(FontAwesomeIcons.robot, color: Colors.blue[400]),
                      SizedBox(width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.05),
                      const Text("Bots")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.database, color: Colors.blue[400]),
                      SizedBox(width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.05),
                      const Text("Knowledge")
                    ],
                  ),
                ),
              ]),
          Flexible(
            child: TabBarView(controller: _tabController, children: [
              buildBotTab(context),
              buildKnowledgeBaseTab(context),
            ]),
          )
        ],
      ),
    );
  }

  Column buildBotTab(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownWidget(
                    display: "Type:",
                    types: ["All", "Published", "Favorites"],
                    onSelect: (m) => {},
                  )),
            ),
            Expanded(child: SearchBarWidget(
              onSubmit: (searchVal) async {
              print(searchVal);
              await _botListNotifier.getBots(searchVal);
              _textController.text = searchVal;
            },
              onSearch: (String value) {  },
              controller: _textController,
              )
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blueAccent),
            child: TextButton(
                onPressed: () =>
                {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          BotCreateDialog(
                            onCreateBot: (BotModel bot) async{
                              RequestResponse res = await _botListNotifier
                                  .createBot(bot);
                              if (res == RequestResponse.success){
                                print("Done");
                                RequestResponse innerResponse =
                                    await _botListNotifier.getBots(null);

                                if (innerResponse == RequestResponse.unauthorized) {
                                  //Logout here.
                                }
                              }
                              if (res == RequestResponse.unauthorized) {
                                //Logout here
                              }
                            },
                          )
                  )
                },
                child: SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.add_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                      Text("Create bot",
                          style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15)),
                    ],
                  ),
                )),
          ),
        ),
        Expanded(child: _buildBotList()),
      ],
    );
  }

  Widget _buildBotList(){
    final List<BotResDto> botList = context.watch<BotListNotifier>().bots.data;
    return _botListNotifier.bots.data.isEmpty ? //true : false
    const NoBotPanel() : BotListView(
        scrollController: _scrollController,
        bots: botList,
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: LoadingAnimationWidget.twistingDots(
          size: 50,
          leftDotColor: TColor.tamarama,
          rightDotColor: TColor.daJuice,
        ),
      ),
    );
  }
    
  Widget buildKnowledgeBaseTab(BuildContext context) {
    return const KnowledgePage();
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Text("Personal",
          style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w800)),
    );
  }

  //
  void _onScroll() {

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200){
      print('Scrolled to more...');
    }
  }
}
