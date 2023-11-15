import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/main.dart';
import 'package:pa_mobile/provider/change_page.dart';
import 'package:pa_mobile/provider/change_theme.dart';
import 'package:pa_mobile/services/user_service.dart';
import 'package:pa_mobile/utils/shared_preference.dart';
import 'changepass.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:provider/provider.dart';

class home extends StatelessWidget {
  final category_atasan = {
    'OUTER': ["Cardigan", "Jaket"],
    'WARM': ["Sweater", "Hoodie"],
    'INNER': ["Kemeja", "Kaos"],
  };
  final category_bawahan = {
    'CELANA': ["Jeans", "Short"],
  };
  final List<List<String>> member = [
    [
      "assets/place.png",
      "assets/time.png",
      "assets/diskon.png",
      "assets/3THRIFT.png"
    ],
    ["Ibnu Yafi", "Hadie Pratama", "Agustina Dwi", "Ayu Lestari"]
  ];

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
                      Provider.of<CustomTheme>(context, listen: false)
                          .preferenced(1);
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
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: FutureBuilder(
                future: userservice().uservalue(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.sizeOf(context).height * 0.125),
                          texts_2(context, snapshot.data["username"], 20,
                              TextAlign.center, FontWeight.normal),
                          texts_2(context, snapshot.data.id, 15,
                              TextAlign.center, FontWeight.normal),
                          button(context, "Change Password", 0.08, 0, 0.7, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    changepass(snapshot.data.id)));
                          }),
                          button(context, "Log Out", 0.02, 0, 0.7, () async {
                            FirebaseAuth.instance.signOut();
                            await preference().delete();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MyApp()),
                                (Route<dynamic> route) => false);
                          })
                        ],
                      );
                    }
                  }
                  return Container(
                    color: ThemeData().scaffoldBackgroundColor,
                    child: Center(child: CircularProgressIndicator()),
                  );
                })));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _homepage(context),
      favorite(context),
      info(context),
      profile(context)
    ];
    return ChangeNotifierProvider<changepage>(
        create: (context) => changepage(),
        child: WillPopScope(onWillPop: () {
          return Future.value(false);
        }, child: Consumer<changepage>(builder: (context, changePage, child) {
          return Scaffold(
              appBar: appbar(context),
              body: pages[changePage.selects],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                unselectedItemColor: Theme.of(context).iconTheme.color,
                selectedItemColor: Theme.of(context).cardColor,
                currentIndex: changePage.selects,
                onTap: (_index) {
                  changePage.change(_index);
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home, size: 35), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.heart, size: 35),
                      label: "favorite"),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.info, size: 35), label: "Info"),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.profile_circled, size: 35),
                      label: "Profile"),
                ],
              ));
        })));
  }
}
