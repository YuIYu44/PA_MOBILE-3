import 'package:flutter/material.dart';

class loveClothes extends ChangeNotifier {
  List<Color>? love;
  Color clr = Colors.black;
  color(index) {
    return love![index];
  }

  loveClothes(Color clr_, int list) {
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
