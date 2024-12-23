import 'package:flutter/material.dart';

class DriveNotifier extends ChangeNotifier {
  String unitName = '';
  void setUnitName(String value) {
    unitName = value;
  }

  bool isUploadLoading = false;
  void setUploadLoading(bool value) {
    isUploadLoading = value;
    notifyListeners();
  }
}
