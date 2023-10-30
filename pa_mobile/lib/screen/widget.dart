import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pa_mobile/screen/user/chosen_clothes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTheme extends ChangeNotifier {
  ThemeData? currentTheme;
  SharedPreferences? prefs;
  bool? dark;
  CustomTheme(int edit) {
    preferenced(edit);
  }
  preferenced(int edit) async {
    final prefs = await SharedPreferences.getInstance();
    bool? dark = prefs.getBool('darkmode');
    if (dark == null && edit == 0) {
      await prefs.setBool('darkmode', true);
    } else if (edit == 1 && dark != null) {
      dark = !dark;
      await prefs.setBool('darkmode', dark);
    }
    if (dark == true) {
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

Widget texts(context, texts, fontsizes, textsalign) {
  return Text(
    texts,
    style: GoogleFonts.lora(
      textStyle: Theme.of(context).textTheme.bodyLarge,
      fontSize: fontsizes + 0.0,
    ),
    textAlign: textsalign,
  );
}

Widget texts_2(context, texts, fontsizes, textsalign, weight) {
  return Text(texts,
      textAlign: textsalign,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: fontsizes + 0.0,
            fontFamily: 'Iceland',
            fontWeight: weight,
          ));
}

Widget button(
    BuildContext context, texts, top, bottom, widths, VoidCallback do_) {
  return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * top,
          bottom: MediaQuery.of(context).size.height * bottom),
      width: MediaQuery.of(context).size.width * widths,
      height: 45,
      child: ElevatedButton(
          onPressed: do_,
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff394867),
              side: BorderSide(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
              )),
          child: Text(texts,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Iceland',
                fontWeight: FontWeight.bold,
              ))));
}

Widget textfields(BuildContext context, TextEditingController controllers,
    bool obscure, String text, double fontsize, double top, double width) {
  return Container(
      width: MediaQuery.sizeOf(context).width * width,
      height: 40,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * top),
      child: TextField(
          controller: controllers,
          obscureText: obscure,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  width: 1),
            ),
            contentPadding: EdgeInsets.only(top: 10, left: 10),
            labelText: text,
            labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: fontsize + 3,
                  fontFamily: 'Iceland',
                  fontWeight: FontWeight.bold,
                ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: fontsize,
                fontFamily: 'Iceland',
                fontWeight: FontWeight.normal,
              )));
}

EdgeInsets customEdgeInsets(BuildContext context, x, y) {
  return EdgeInsets.fromLTRB(
      MediaQuery.of(context).size.width * x,
      MediaQuery.of(context).size.height * y,
      MediaQuery.of(context).size.width * x,
      MediaQuery.of(context).size.height * y);
}

PreferredSizeWidget appbar(context) {
  return AppBar(
    titleSpacing: 20,
    centerTitle: false,
    automaticallyImplyLeading: false,
    toolbarHeight: 90,
    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 20),
          width: 60,
          height: 60,
          child: ClipOval(
            child: Image.asset(
              'assets/3THRIFT.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        texts(
          context,
          'THRIFTSTORE',
          20.0,
          TextAlign.left,
        ),
      ],
    ),
  );
}

Widget carousel(circulars, edge, images) {
  return Container(
    margin: EdgeInsets.all(edge),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(circulars),
      image: DecorationImage(
        image: AssetImage(images),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget category(context, Category) {
  return GridView.count(
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 3),
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(Category.keys.length, (index) {
        return Column(
          children: [
            texts_2(context, Category.keys.elementAt(index), 15, TextAlign.left,
                FontWeight.bold),
            Container(
                height: MediaQuery.of(context).size.height * 0.13,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Category[Category.keys.elementAt(index)]!.length,
                    itemBuilder: (BuildContext context, int index2) {
                      return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: 10,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.02),
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: MediaQuery.of(context).size.width * 0.08,
                              child: Image.asset(
                                "assets/clothes/" +
                                    Category[Category.keys.elementAt(index)]![
                                        index2] +
                                    ".png",
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              chosen_clothes(Category[
                                                      Category.keys.elementAt(
                                                          index)]![index2]
                                                  .toString()
                                                  .toUpperCase())));
                                },
                                child: texts_2(
                                    context,
                                    Category[Category.keys.elementAt(index)]![
                                        index2],
                                    MediaQuery.sizeOf(context).width * 0.03,
                                    TextAlign.left,
                                    FontWeight.normal))
                          ]);
                    }))
          ],
        );
      }));
}