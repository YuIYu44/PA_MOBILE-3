import 'package:flutter/material.dart';

class FavClothes extends ChangeNotifier {
  List<Map<dynamic, dynamic>> clothes = [{}];
  List<Map<dynamic, dynamic>> get favorite => clothes;
  add(List clothes_) {
    clothes = clothes_.map((e) => e as Map<dynamic, dynamic>).toList();
  }

  delete(id) {
    clothes.removeWhere((element) => element.keys == id);
    notifyListeners();
  }

  deleteproduct(id) {
    clothes.removeWhere((element) => element.keys == id);
  }
}
