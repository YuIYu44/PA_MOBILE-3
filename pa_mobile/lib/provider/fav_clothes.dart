import 'package:flutter/material.dart';

class fav_clothes extends ChangeNotifier {
  Map<dynamic, dynamic> clothes = {};
  Map<dynamic, dynamic> get favorite => clothes;
  add(clothes_) {
    clothes = clothes_;
  }

  delete(id) {
    clothes.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  deleteproduct(id) {
    clothes..removeWhere((key, value) => key == id);
  }
}
