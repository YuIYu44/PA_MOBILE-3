import 'package:flutter/material.dart';
import 'package:pa_mobile/utils/shared_preference.dart';

class CustomTheme extends ChangeNotifier {
  ThemeData? currentTheme;
  String? dark;
  CustomTheme(int edit) {
    preferenced(edit);
  }
  preferenced(int edit) async {
    dark = await preference().get('darkmode');
    if (dark == null) {
      await preference().set('darkmode', "light");
    } else if (edit == 1 && dark != null) {
      dark = (dark == "dark" ? "light" : "dark");
      await preference().set('darkmode', dark);
    }
    if (dark == "dark") {
      setDarkmode();
    } else {
      setLightMode();
    }
  }

  setLightMode() {
    currentTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xffF1F6F9),
      iconTheme: IconThemeData(color: Color(0xff212A3E)),
      cardColor: Color(0xEE9BA4B5),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    );
    notifyListeners();
  }

  setDarkmode() {
    currentTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xff212A3E),
      cardColor: Color(0xff394867),
      iconTheme: IconThemeData(color: Color(0xffF1F6F9)),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
      ),
    );
    notifyListeners();
  }
}
