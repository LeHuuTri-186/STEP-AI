import 'package:flutter/material.dart';

class ConfluenceNotifier extends ChangeNotifier {
  String unitName = '';
  String slackWorkspace = '';
  String slackBotToken = '';
  void setUnitName(String value) {
    unitName = value;
  }

  void setSlackWorkspace(String value) {
    slackWorkspace = value;
  }

  void setSlackBotToken(String value) {
    slackBotToken = value;
  }

  bool isUploadLoading = false;
  void setUploadLoading(bool value) {
    isUploadLoading = value;
    notifyListeners();
  }
}
