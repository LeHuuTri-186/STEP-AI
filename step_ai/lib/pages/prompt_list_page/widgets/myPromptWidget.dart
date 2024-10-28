import 'package:flutter/cupertino.dart';
import 'package:step_ai/pages/prompt_list_page/models/prompt.dart';
import 'package:step_ai/pages/prompt_list_page/widgets/personalPromptTile.dart';
import 'package:step_ai/pages/prompt_list_page/widgets/publicPromptTile.dart';

class MyPromptWidget extends StatefulWidget{
  List<Prompt> myPrompts;
  List<Prompt> publicPrompts;
  MyPromptWidget ({required this.myPrompts, required this.publicPrompts});

  @override
  _MyPromptState createState() => _MyPromptState();
}

class _MyPromptState extends State<MyPromptWidget>{
  late List<Prompt> personalItems;
  late List<Prompt> publicItems;
  @override
  void initState() {
    super.initState();
    personalItems = widget.myPrompts;
    publicItems = widget.publicPrompts ?? [];
  }

  void addItem(String newItem) {
    setState(() {
      personalItems.add(newItem as Prompt);
      publicItems.add(newItem as Prompt);
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          ...personalItems.map((prompt) {
            return PersonalPromptTile(prompt: prompt);
          }).toList(),
          ...publicItems.map((prompt) {
            return PublicPromptTile(prompt: prompt);
          }).toList(),
        ],
    );
  }

}