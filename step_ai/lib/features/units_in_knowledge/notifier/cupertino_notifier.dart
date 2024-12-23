import 'package:flutter/material.dart';

class CupertinoNotifier extends ChangeNotifier{
  bool isLoading = false;
  bool switchValue = false;

  void changeSwitchValue(bool value) {
    switchValue = value;
  }
  void changeIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }
    void initialize(bool initialValue) {
    switchValue = initialValue;
  }
}