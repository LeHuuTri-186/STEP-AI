import 'dart:async';

import 'package:flutter/material.dart';

class PrivateFilterState extends ChangeNotifier {
  String? _searchQuery;

  Timer? _debounce;

  String? get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    if (query == _searchQuery) {
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQuery = query;
      notifyListeners();
    });
  }
}
