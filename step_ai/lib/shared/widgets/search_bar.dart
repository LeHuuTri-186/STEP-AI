import 'package:flutter/material.dart';
import 'package:step_ai/shared/styles/varela_round_style.dart';

import '../styles/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = "Search...",
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onChanged(_controller.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.grahamHair,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        style: VarelaRoundStyle.basicW600.copyWith(
          color: TColor.squidInk,
          fontSize: 15,
        ),
        cursorColor: TColor.squidInk,
        controller: _controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: TColor.petRock,
              )),
          hintText: widget.hintText,
          hintStyle: VarelaRoundStyle.basic.copyWith(
            color: TColor.petRock,
            fontSize: 15
          ),
          prefixIcon: Icon(
            Icons.search,
            color: TColor.squidInk,
          ),
          suffixIcon: _controller.text.trim().isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: TColor.petRock,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged(""); // Clear the search text
                  },
                )
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
