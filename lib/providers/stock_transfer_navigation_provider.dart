import 'package:flutter/material.dart';

class StockTransferNavigationProvider with ChangeNotifier {
  int _selectedPageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;

  set selectedPageIndex(int value) {
    _selectedPageIndex = value;
    notifyListeners();
  }
}