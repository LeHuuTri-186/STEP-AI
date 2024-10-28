import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/prompt.dart';

class PublicPromptTile extends StatefulWidget{
  final Prompt prompt;
  PublicPromptTile({required this.prompt});

  @override
  _PublicPromptState createState() => _PublicPromptState();
}

class _PublicPromptState extends State<PublicPromptTile>{
  late Prompt item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = widget.prompt;
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: item.description != null ? Text(item.description) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: starPressed, icon: Icon(Icons.star_border)),
          IconButton(onPressed: infoPressed, icon: Icon(Icons.info_outline))
        ],
      ),
      onTap: itemPressed,
    );
  }


  void starPressed() {
    print('Pressed Star in ${item.title} ');
  }

  void infoPressed() {
    print('Pressed Info in ${item.title}');
  }

  void itemPressed() {
    print('Pressed item ${item.title}');
  }
}