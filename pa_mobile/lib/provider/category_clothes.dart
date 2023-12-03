import 'package:flutter/material.dart';

class CategoryClothes extends ChangeNotifier {
  String category = 'Kemeja';
  String get getCategory => category;
  
  changecategory(String category_) {
    category = category_;
    notifyListeners();
  }
}
