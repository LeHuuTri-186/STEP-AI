import 'package:flutter/material.dart';

class EmailOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;

  EmailOptionTile({Key? key, required this.icon, required this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        margin: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(icon, size: 25, color: Colors.white),
            const SizedBox(width: 8), 
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white), 
            ),
          ],
        ),
      ),
    );
  }
}