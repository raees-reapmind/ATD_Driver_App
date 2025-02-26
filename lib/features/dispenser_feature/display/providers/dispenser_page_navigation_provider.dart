import 'package:flutter/material.dart';

class DispenserPageNavigationProvider with ChangeNotifier {
  int _selectedPageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;

  set selectedPageIndex(int value) {
    _selectedPageIndex = value;
    notifyListeners();
  }
}