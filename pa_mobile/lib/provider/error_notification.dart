import 'package:flutter/material.dart';

class ErrorNote extends ChangeNotifier {
  String error_ = "";
  String get notif => error_;
  change(errors) {
    error_ = errors;
    notifyListeners();
  }
}
