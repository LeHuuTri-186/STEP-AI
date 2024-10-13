import 'package:flutter/material.dart';

class DropdownAI extends StatefulWidget {
  const DropdownAI({super.key});

  @override
  State<DropdownAI> createState() => _DropdownAIState();
}

class _DropdownAIState extends State<DropdownAI> {
  String selectedOption = 'GPT';
  List<String> options = ['GPT', 'Bing', 'Gemini'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.only(top:5,left: 10),
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: DropdownButton<String>(
        isDense: true, 
        value: selectedOption,
        onChanged: (String? newValue) {
          setState(() {
            selectedOption = newValue!;
          });
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(child: Text(value, style: const TextStyle(fontSize: 16), )),
          );
        }).toList(),
        style: const TextStyle(color: Colors.white), 
        dropdownColor: Colors.grey[500],
       
      ),
    );
  }
}