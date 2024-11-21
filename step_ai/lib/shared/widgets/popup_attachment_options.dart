import 'package:flutter/material.dart';

class PopupAttachmentOptions extends StatelessWidget {
  const PopupAttachmentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(25, -155),
      position: PopupMenuPosition.over,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: 'file',
            child: Row(
              children: const [
                Icon(Icons.file_present),
                SizedBox(width: 10),
                Text('File'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'camera',
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                SizedBox(width: 10),
                Text('Camera'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'gallery',
            child: Row(
              children: const [
                Icon(Icons.image),
                SizedBox(width: 10),
                Text('Gallery'),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'file':
            // Handle file selection
            break;
          case 'camera':
            // Handle camera
            break;
          case 'gallery':
            // Handle gallery
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: const Icon(Icons.add,size: 30,),
      ),
    )
    ;
  }
}
