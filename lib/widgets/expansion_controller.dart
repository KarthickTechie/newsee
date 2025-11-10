import 'package:flutter/material.dart';

class ExpansionController extends ChangeNotifier {
  int? _expandedIndex;

  int? get expandedIndex => _expandedIndex;

  void expand(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = null;
    } else {
      _expandedIndex = index;
    }
    notifyListeners();
  }
}


