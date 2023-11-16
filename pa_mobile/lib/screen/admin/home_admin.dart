import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/main.dart';
import 'package:pa_mobile/screen/admin/crud/add.dart';
import 'package:pa_mobile/screen/admin/crud/edit.dart';
import 'package:pa_mobile/provider/change_page.dart';
import 'package:pa_mobile/provider/change_theme.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/utils/shared_preference.dart';
import 'package:provider/provider.dart';

class home_admin extends StatelessWidget {
  home_admin({super.key});

  // final List<String> category_atasan = [
  //   "Cardigan",
  //   "Jaket",
  //   "Sweater",
  //   "Hoodie",
  //   "Kemeja",
  //   "Kaos",
  //   "Celana"
  // ];
  final List<List<String>> member = [
    [
      "assets/place.png",
      "assets/time.png",
      "assets/diskon.png",
      "assets/3THRIFT.png"
    ],
    ["100.000", "142.500", "200.000", "550.000"]
  ];

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
                Provider.of<CustomTheme>(context, listen: false).preferenced(1);
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
                                    onPressed: () {},
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
                                    },
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<changepage>(create: (context) => changepage())
        ],
        child: WillPopScope(onWillPop: () {
          return Future.value(false);
        }, child: Consumer<changepage>(builder: (context, changePage, child) {
          return Scaffold(
            appBar: appbar(context),
            body: pages[changePage.selects],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              unselectedItemColor: Theme.of(context).cardColor,
              selectedItemColor: Theme.of(context).iconTheme.color,
              currentIndex: changePage.selects,
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
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                              await preference().delete();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                  (Route<dynamic> route) => false);
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  changePage.change(index);
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        })));
  }
}
