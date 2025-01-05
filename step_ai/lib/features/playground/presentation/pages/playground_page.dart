import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:step_ai/config/enum/request_response.dart';
import 'package:step_ai/core/di/service_locator.dart';

import 'package:step_ai/shared/styles/colors.dart';

import 'package:step_ai/features/knowledge_base/presentation/pages/knowledge_page.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';
import 'package:step_ai/shared/styles/vertical_spacing.dart';

import 'package:step_ai/shared/widgets/history_drawer.dart';

import '../../../../shared/widgets/search_bar.dart';
import '../../data/models/bot_model.dart';
import '../../data/models/bot_res_dto.dart';
import '../notifier/bot_list_notifier.dart';
import '../widgets/bot_list_panel.dart';
import '../widgets/create_bot_dialog.dart';
import '../widgets/no_bot_panel.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage>
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

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: HistoryDrawer(),
      body: Column(
        children: [
          TabBar(
            labelColor: TColor.tamarama,
            unselectedLabelColor: TColor.slate,
              overlayColor: WidgetStatePropertyAll(TColor.doctorWhite),
              splashFactory: NoSplash.splashFactory,
              indicatorColor: TColor.tamarama,
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              controller: _tabController,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FontAwesomeIcons.readme),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
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
                      const Icon(FontAwesomeIcons.database),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
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

  Widget buildBotTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VSpacing.sm,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: CustomSearchBar(
                    onChanged: (searchVal) async {
                      await _botListNotifier.getBots(searchVal);
                      _textController.text = searchVal;
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
          HSpacing.sm,
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => {
                          showDialog(
                              context: context,
                              builder: (context) => BotCreateDialog(
                                    onCreateBot: (BotModel bot) async {
                                      RequestResponse res =
                                          await _botListNotifier.createBot(bot);
                                      if (res == RequestResponse.success) {
                                        RequestResponse innerResponse =
                                            await _botListNotifier.getBots(null);

                                        if (innerResponse ==
                                            RequestResponse.unauthorized) {
                                          //Logout here.
                                        }
                                      }
                                      if (res == RequestResponse.unauthorized) {
                                        //Logout here
                                      }
                                    },
                                  ))
                        },
                    borderRadius: BorderRadius.circular(50),
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: TColor.tamarama,),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.add_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text("Create bot",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: TColor.doctorWhite,

                                )),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
          _botListNotifier.isLoading
              ? _buildProgressIndicator()
              : Expanded(child: _buildBotList()),
        ],
      ),
    );
  }

  Widget _buildBotList() {
    final List<BotResDto> botList = context.watch<BotListNotifier>().bots.data;
    return _botListNotifier.bots.data.isEmpty
        ? //true : false
        const NoBotPanel()
        : BotListView(
            scrollController: _scrollController,
            bots: botList,
          );
  }

  Widget _buildProgressIndicator() {
    return Expanded(
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
      centerTitle: true,
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
      title: const Text(
        "Playground",
      ),
    );
  }

  //
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
    }
  }
}
