import 'package:flutter/material.dart';

class LocalFileNotifier extends ChangeNotifier {
  final Map<String, String> acceptTypeMap = {
    'txt': 'text/plain',
    'pdf': 'application/pdf',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'html': 'text/html',
    'java': 'text/x-java',
    'c': 'text/x-csrc',
    'cpp': 'text/x-c++src',
    'tex': 'text/x-tex',
  };
  bool isUploadLoading = false;
  void changeUploadLoading(bool value) {
    isUploadLoading = value;
    notifyListeners();
  }
  List<String> get acceptTypeFile => acceptTypeMap.keys.toList();

  String getMimeType(String extension) {
    return acceptTypeMap[extension.toLowerCase()] ?? 'text/plain';
  }

  String fileName = "";
  void changeFileName(String name) {
    fileName = name;
    notifyListeners();
  }
}
