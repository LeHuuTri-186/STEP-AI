import 'package:flutter/material.dart';

class AddOptionUnitNotifier extends ChangeNotifier {
  String selectedOption="local_file";
  void setSelectedOption(String value) {
    selectedOption = value;
    notifyListeners();
  }
}
