import 'package:flutter/material.dart';

class WebNotifier extends ChangeNotifier {
  String nameUnit = '';
  String webUrl = '';
  void setNameUnit(String value) {
    nameUnit = value;
  }

  void setWebUrl(String value) {
    webUrl = value;
  }

  bool isUploadLoading = false;
  void setUploadLoading(bool value) {
    isUploadLoading = value;
    notifyListeners();
  }
}
