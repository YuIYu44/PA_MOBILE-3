import 'package:flutter/material.dart';

class error extends ChangeNotifier {
  String error_ = "";
  String get notif => error_;
  change(errors) {
    error_ = errors;
    notifyListeners();
  }
}
