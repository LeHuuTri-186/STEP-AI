import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/prompt.dart';

class PersonalPromptTile extends StatefulWidget{
  final Prompt prompt;
  PersonalPromptTile({required this.prompt});
  @override
  _PersonalPromptState createState() => _PersonalPromptState();
}

class _PersonalPromptState extends State<PersonalPromptTile>{
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
          IconButton(onPressed: editPressed, icon: Icon(Icons.edit)),
        ],
      ),
      onTap: itemPressed,
    );
  }



  void editPressed() {
  }

  void itemPressed() {
  }
}