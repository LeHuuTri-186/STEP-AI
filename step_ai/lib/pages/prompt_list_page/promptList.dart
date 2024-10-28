import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/pages/prompt_list_page/widgets/myPromptWidget.dart';
import 'package:step_ai/pages/prompt_list_page/widgets/publicPromptWidget.dart';
import 'models/prompt.dart';

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PromptLibraryScreen();
  }

}

class PromptLibraryScreen extends StatefulWidget{
  @override
  _PromptLibraryScreenState createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen> with SingleTickerProviderStateMixin{

  List<String> chipLabels = ['All', 'Marketing', 'Business', 'SEO', 'IT', 'Mathematics']; //temporary set.
  List<Prompt> promptList = [
    Prompt(title: 'Chatbot AI', description: 'Hỗ trợ trả lời câu hỏi nhanh chóng và chính xác.'),
    Prompt(title: 'Phân tích văn bản', description: 'Phân tích và xử lý văn bản chuyên sâu.'),
    Prompt(title: 'Tạo hình ảnh AI', description: 'Sử dụng AI để tạo hình ảnh từ mô tả.'),
    Prompt(title: 'Dịch ngôn ngữ', description: 'Dịch ngôn ngữ tự động qua AI.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
  ]; //temporary set

  List<Prompt> personalPrompt = [
    Prompt(title: 'Tạo hình ảnh AI', description: 'Sử dụng AI để tạo hình ảnh từ mô tả.'),
    Prompt(title: 'Dịch ngôn ngữ', description: 'Dịch ngôn ngữ tự động qua AI.'),
  ];
  List<Prompt> publicPrompt = [
    Prompt(title: 'Tóm tắt văn bản', description: 'Tóm tắt văn bản dài thành những ý chính.'),
  ];

  int _index = 0;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _index = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Prompt Library", style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * 0.05),)
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
      body: Column(
        children: [
          Theme(data: ThemeData(
            tabBarTheme: TabBarTheme(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            )
          ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              tabs: [
                Tab(text: 'My Prompts',),
                Tab(text: 'Public Prompts',)
              ],
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MyPromptWidget(myPrompts: personalPrompt, publicPrompts: publicPrompt),
                  PublicPromptWidget(tags: chipLabels, prompts: promptList), //PublicPrompts
                ],
              )
          ),
        ],
      ),
    );
  }
}

