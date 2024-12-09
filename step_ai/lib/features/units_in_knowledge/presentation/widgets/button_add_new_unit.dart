import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonAddNewUnit extends StatelessWidget {
  const ButtonAddNewUnit({super.key});
  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Text("Add unit dialog"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(right: 6),
      padding: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.only(right: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueAccent,
        ),
        child: TextButton(
          onPressed: () => _showAddDialog(context),
          child: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  "Add unit",
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
