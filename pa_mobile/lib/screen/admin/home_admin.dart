// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/admin/crud/add.dart';
import 'package:pa_mobile/screen/admin/crud/edit.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:provider/provider.dart';

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
  ["100.000", "142.500", "200.000", "550.000"]
];

class homeadminstate extends State<home_admin> {
  int _index = 0;

  Widget home(BuildContext context) {
    return Padding(
      padding: customEdgeInsets(context, 0.03, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.8),
            child: IconButton(
              icon: const Icon(CupertinoIcons.moon, size: 30),
              onPressed: () {
                final themeProvider =
                    Provider.of<CustomTheme>(context, listen: false);
                setState(() {
                  themeProvider.preferenced(1);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: member[0].length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Column(
                                children: [
                                  texts_2(
                                      context,
                                      "Rp. ${member[1][index]}",
                                      16,
                                      TextAlign.start,
                                      FontWeight.bold), //harga
                                  texts_2(context, "keterangan", 13,
                                      TextAlign.start, FontWeight.normal)
                                ],
                              ),
                            ), //keterangan
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {}, //delete data => database
                                    icon: const Icon(
                                      CupertinoIcons.trash,
                                      size: 35,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const editScreen()));
                                    }, //edit data => database
                                    icon: const Icon(CupertinoIcons.pen,
                                        size: 35)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      home(context),
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
          unselectedItemColor: Theme.of(context).cardColor,
          selectedItemColor: Theme.of(context).iconTheme.color,
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: Theme.of(context).iconTheme.color,
                size: 35,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.arrow_left_square,
                color: Theme.of(context).iconTheme.color,
                size: 35,
              ),
              label: "Logout",
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Logout"),
                    content: const Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Home tab pressed
              setState(() {
                _index = index;
              });
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).cardColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const addScreen()));
          },
          child: Icon(
            CupertinoIcons.add_circled,
            color: Theme.of(context).iconTheme.color,
            size: 50,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
