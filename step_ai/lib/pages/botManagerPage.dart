import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BotManagerPage extends StatefulWidget {
  const BotManagerPage({super.key});

  @override
  State<BotManagerPage> createState() => _BotManagerPageState();
}

class _BotManagerPageState extends State<BotManagerPage> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.blue[400],
              labelStyle: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.w800
              ),
              controller: _tabController,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(FontAwesomeIcons.robot, color: Colors.blue[400]),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                        Text("Bots")
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
                        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                        Text("Knowledge")
                      ],
                    ),
                  ),
                ]),
            TabBarView(
              controller: _tabController,
                children: [
                  Column(
                    children: [
            Text("Demo")
                    ],
                  ),Column(
                    children: [
                      Row(
                        children: [
                          Text("Demo1")
    ],
                      )
                    ],
                  )
                  ])
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: false,
      leading: const Icon(Icons.person_2_outlined),
      title: Text("Personal", style: GoogleFonts.jetBrainsMono(
        fontWeight: FontWeight.w800
      )),
    );
  }
}
