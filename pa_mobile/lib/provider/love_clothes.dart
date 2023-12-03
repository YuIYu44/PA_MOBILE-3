import 'package:flutter/material.dart';

class LoveClothes extends ChangeNotifier {
  List<Color>? love;
  Color clr = Colors.black;
  color(index) {
    return love![index];
  }

  LoveClothes(Color clr_, int list) {
    love = List.generate(list, (index) => clr_);
    clr = clr_;
  }
  atfavorite(index, color) {
    love![index] = color;
  }

  changelove(index, color) {
    love![index] = color;
    notifyListeners();
  }
}
