import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_ai/pages/prompt_list_page/widgets/publicPromptTile.dart';

import '../models/prompt.dart';

class PublicPromptWidget extends StatefulWidget {
  final List<String> tags;
  final List<Prompt> prompts;
  PublicPromptWidget({required this.tags, required this.prompts});
  _PublicPromptState createState() => _PublicPromptState();
}

class _PublicPromptState extends State<PublicPromptWidget>{
  late List<String> items;
  late List<Prompt> promptItems;
  String selectedChip = 'All';

  @override
  void initState() {
    super.initState();
    items = widget.tags;
    debugPrint("Tags received: $items");
    debugPrint("Prompts received: ${widget.prompts}");
    promptItems = widget.prompts ?? [];
  }

  void addItem(String newItem) {
    setState(() {
      items.add(newItem as String);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )
            ),
          ),
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: items.map((label) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Text(
                    label,
                    style: TextStyle(
                      color: selectedChip == label? Colors.white : Colors.black,
                    ),
                  ),
                  selected: selectedChip == label, // Example: mark 'All' as selected by default
                  selectedColor: Colors.blue,
                  onSelected: (selected){
                    setState(() {
                      selectedChip =label;
                    });
                    //Action
                    print("Selected chip: $label");
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView(
            children: promptItems.map((prompt) {
              return PublicPromptTile(prompt: prompt);
            }).toList(),
          ),
        ),
      ],
    );

    // TODO: implement build
    throw UnimplementedError();
  }
}