import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'changepass.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:provider/provider.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => homeState();
}

var category_atasan = {
  'OUTER': ["Cardigan", "Jaket"],
  'WARM': ["Sweater", "Hoodie"],
  'INNER': ["Kemeja", "Kaos"],
};
var category_bawahan = {
  'CELANA': ["Jeans", "Short"],
};
List<List<String>> member = [
  [
    "assets/place.png",
    "assets/time.png",
    "assets/diskon.png",
    "assets/3THRIFT.png"
  ],
  ["Ibnu Yafi", "Hadie Pratama", "Agustina Dwi", "Ayu Lestari"]
];

class homeState extends State<home> {
  int _index = 0;

  Widget _homepage(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: customEdgeInsets(context, 0.03, 0),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.8,
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: IconButton(
                    icon: Icon(CupertinoIcons.moon, size: 30),
                    onPressed: () {
                      final themeProvider =
                          Provider.of<CustomTheme>(context, listen: false);
                      setState(() {
                        themeProvider.preferenced(1);
                      });
                    }),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                child: CarouselSlider(
                  items: [
                    carousel(10.0, 8.0, "assets/place.png"),
                    carousel(10.0, 8.0, "assets/time.png"),
                    carousel(10.0, 8.0, "assets/diskon.png"),
                  ],
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    viewportFraction: 0.8,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 80),
                  width: MediaQuery.of(context).size.width * 0.93,
                  child: category(context, category_atasan)),
              category(context, category_bawahan)
            ])));
  }

  Widget favorite(BuildContext context) {
    return Padding(
      padding: customEdgeInsets(context, 0.03, 0.02),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: member[0].length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset(
                      member[0][index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      color: Theme.of(context).cardColor,
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.58,
                      child: Row(children: [
                        Container(
                            color: Theme.of(context).cardColor,
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Column(children: [
                              texts_2(context, "Rp ${member[1][index]}", 16,
                                  TextAlign.start, FontWeight.bold), //harga
                              texts_2(context, "keterangan", 13,
                                  TextAlign.start, FontWeight.normal)
                            ])), //keterangan

                        IconButton(
                            onPressed: () {},
                            icon: Icon(CupertinoIcons
                                .trash)) //delete favorite => database
                      ]))
                ]));
          }),
    );
  }

  Widget info(BuildContext context) {
    return Padding(
      padding: customEdgeInsets(context, 0.03, 0.02),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: member[0].length,
          itemBuilder: (BuildContext context, int index) {
            return Row(children: [
              Container(
                margin: EdgeInsets.only(
                    right: 20,
                    bottom: MediaQuery.of(context).size.height * 0.05),
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
                child: ClipOval(
                  child: Image.asset(
                    member[0][index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  child: texts_2(context, member[1][index], 20, TextAlign.start,
                      FontWeight.bold))
            ]);
          }),
    );
  }

  Widget profile(BuildContext context) {
    return Center(
        child: Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          texts_2(context, "Username", 18, TextAlign.center, FontWeight.normal),
          texts_2(context, "email@gmail.com", 15, TextAlign.center,
              FontWeight.normal),
          button(context, "Change Password", 0.08, 0, 0.7, () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => changepass()));
          }),
          button(context, "Log Out", 0.02, 0, 0.7, () async {
            //await deletepref(); //delete preference
            Navigator.pop(context);
          })
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _homepage(context),
      favorite(context),
      info(context),
      profile(context)
    ];
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: appbar(context),
          body: pages[_index],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            unselectedItemColor: Theme.of(context).iconTheme.color,
            selectedItemColor: Theme.of(context).cardColor,
            currentIndex: _index,
            onTap: (index) {
              if (index != _index) {
                setState(() {
                  _index = index;
                });
              }
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home, size: 35), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart_fill, size: 35),
                  label: "favorite"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.info, size: 35), label: "Info"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled, size: 35),
                  label: "Profile"),
            ],
          ),
        ));
  }
}
