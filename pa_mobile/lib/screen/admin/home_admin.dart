import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';

class home_admin extends StatefulWidget {
  const home_admin({super.key});

  @override
  State<home_admin> createState() => homeadminstate();
}

List<String> category_atasan = [
  "Cardigan",
  "Jaket",
  "Sweater",
  "Hoodie",
  "Kemeja",
  "Kaos",
  "Celana"
];
List<List<String>> member = [
  ["place.png", "time.png", "diskon.png", "3THRIFT.png"],
  ["Ibnu Yafi", "Hadie Pratama", "Agustina Dwi", "Ayu Lestari"]
];

class homeadminstate extends State<home_admin> {
  int _index = 0;

  Widget home(BuildContext context) {
    return Padding(
        padding: customEdgeInsets(context, 0.03, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.8),
              child: IconButton(
                icon: Icon(CupertinoIcons.moon, size: 30),
                onPressed: () {},
              )),
          ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: member[0].length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.only(top: 20),
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
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Column(children: [
                                  texts_2(context, "Rp ${member[1][index]}", 16,
                                      TextAlign.start, FontWeight.bold), //harga
                                  texts_2(context, "keterangan", 13,
                                      TextAlign.start, FontWeight.normal)
                                ])), //keterangan
                            Row(children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(CupertinoIcons
                                      .trash)), //delete favorite => database
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(CupertinoIcons
                                      .pen)) //edit favorite => database
                            ])
                          ]))
                    ]));
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      home(context),
      // add(context),
    ];
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          appBar: appbar(context),
          body: pages[_index],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _index = 1;
            },
            child: Icon(CupertinoIcons.add_circled,
                color: Theme.of(context).iconTheme.color, size: 35),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).scaffoldBackgroundColor,
            notchMargin: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(CupertinoIcons.home,
                      color: Theme.of(context).iconTheme.color, size: 35),
                  onPressed: () {
                    _index = 0;
                  },
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.arrow_left_square,
                      color: Theme.of(context).iconTheme.color, size: 35),
                  onPressed: () {
                    //await deletepref(); //delete preference
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
