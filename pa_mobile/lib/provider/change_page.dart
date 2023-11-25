import 'package:flutter/material.dart';

class ChangePage extends ChangeNotifier {
  int selected = 0;
  int get selects => selected;
  change(index) {
    selected = index;
    notifyListeners();
  }
}
