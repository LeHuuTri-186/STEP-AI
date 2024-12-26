import 'package:flutter/material.dart';

class FormModel with ChangeNotifier {
  final GlobalKey<FormState> publicFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> privateFormKey = GlobalKey<FormState>();

  bool _isPublic = false;

  bool get isPublic => _isPublic;

  void toggleIsPublic(bool isPublic) {
    _isPublic = isPublic;
    notifyListeners();
  }
}