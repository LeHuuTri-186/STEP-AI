import 'package:flutter/material.dart';

class ConfluenceNotifier extends ChangeNotifier {
  String unitName = '';
  String wikiPageUrl = '';
  String confluenceUsername = '';
  String confluenceAccessToken = '';

  void setUnitName(String value) {
    unitName = value;
  }

  void setWikiPageUrl(String value) {
    wikiPageUrl = value;
  }

  void setConfluenceUsername(String value) {
    confluenceUsername = value;
  }

  void setConfluenceAccessToken(String value) {
    confluenceAccessToken = value;
  }

  bool isUploadLoading = false;
  void setUploadLoading(bool value) {
    isUploadLoading = value;
    notifyListeners();
  }
}
