import 'dart:async';

import 'package:flutter/material.dart';

class PublicFilterState extends ChangeNotifier {
  bool _isFavorite = false;
  String _category = 'All';
  String? _searchQuery;

  final List<String> _categories = [
    "All",
    "Marketing",
    "Business",
    "SEO",
    "Writing",
    "Coding",
    "Career",
    "Chatbot",
    "Education",
    "Fun",
    "Productivity",
    "Other",
  ];

  Timer? _debounce;

  bool get isFavorite => _isFavorite;
  String get category => _category;
  String? get searchQuery => _searchQuery;
  List<String> get categories => _categories;

  void setFavorite(bool favorite) {
    _isFavorite = favorite;
    notifyListeners();
  }

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }

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
