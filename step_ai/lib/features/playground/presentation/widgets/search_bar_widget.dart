import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final Function(String)? onSubmit;
  final Color backgroundColor;
  final bool hasBorder;
  final TextEditingController controller;

  const SearchBarWidget({
    Key? key,
    required this.onSearch,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = true,
    this.onSubmit,
    required this.controller}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        filled: true,
        hintText: "Search",
        hintStyle: GoogleFonts.jetBrainsMono(
          color: Colors.grey
        ),
        hoverColor: widget.backgroundColor,
        fillColor: widget.backgroundColor,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo,
                width: widget.hasBorder ? 1.0: 0
            ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24,
            width: widget.hasBorder ? 1.0: 0
          )
        ),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: widget.onSearch,
      onSubmitted: widget.onSubmit,// Pass the search query back to the parent
    );
  }
}