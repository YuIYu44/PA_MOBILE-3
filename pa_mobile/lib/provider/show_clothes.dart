import 'package:flutter/material.dart';

class ShowClothes extends ChangeNotifier {
  List<String> clothes = [];
  List<String> get favorite => clothes;

  add(clothes_) {
    clothes = clothes_.map<String>((item) => item.toString()).toList();
  }

  delete(id) {
    clothes.removeWhere((element) => element == id);
    notifyListeners();
  }

  deleteproduct(id) {
    clothes.removeWhere((element) => element == id);
  }
}
