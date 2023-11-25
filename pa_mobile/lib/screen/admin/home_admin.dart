import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/admin/crud/add.dart';
import 'package:pa_mobile/screen/admin/crud/edit.dart';
import 'package:pa_mobile/provider/change_page.dart';
import 'package:pa_mobile/provider/change_theme.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:provider/provider.dart';

class home_admin extends StatefulWidget {
  home_admin({super.key});

  @override
  State<home_admin> createState() => _home_adminState();
}

class _home_adminState extends State<home_admin> {
  // final List<String> category_atasan = [
  Future<String> _getImage(photoPath) async {
    final ref = FirebaseStorage.instance.ref().child(photoPath);
    String url = await ref.getDownloadURL();
    return url;
  }

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
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection("product").get(),
              builder: (BuildContext context, snapshot) {
                return (snapshot.hasData)
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: FutureBuilder<String>(
                                      future: _getImage(
                                          "product/${snapshot.data!.docs[index].id}.${snapshot.data!.docs[index].get('ekstensi')}"),
                                      builder: (context,
                                          AsyncSnapshot<String> snapshot2) {
                                        return (snapshot2.hasData)
                                            ? Image.network(
                                                snapshot2.data!,
                                                fit: BoxFit.cover,
                                              )
                                            : Container();
                                      }),
                                ),
                                Container(
                                  color: Theme.of(context).cardColor,
                                  height:
                                      MediaQuery.of(context).size.width * 0.35,
                                  width:
                                      MediaQuery.of(context).size.width * 0.58,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: Column(
                                          children: [
                                            texts_2(
                                                context,
                                                "Rp. ${snapshot.data!.docs[index].get('harga')}",
                                                16,
                                                TextAlign.start,
                                                FontWeight.bold), //harga
                                            texts_2(
                                                context,
                                                snapshot.data!.docs[index]
                                                    .get('deskripsi'),
                                                13,
                                                TextAlign.start,
                                                FontWeight.normal)
                                          ],
                                        ),
                                      ), //keterangan
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                FirebaseFirestore.instance
                                                    .collection("product")
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .delete();

                                                final desertRef = FirebaseStorage
                                                    .instance
                                                    .ref()
                                                    .child(
                                                        "product/${snapshot.data!.docs[index].id}.${snapshot.data!.docs[index].get('ekstensi')}");

                                                await desertRef.delete();
                                              },
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
                                              icon: const Icon(
                                                  CupertinoIcons.pen,
                                                  size: 35)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : const Text("Kosong");
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
          ChangeNotifierProvider<ChangePage>(create: (context) => ChangePage())
        ],
        child: WillPopScope(onWillPop: () {
          return Future.value(false);
        }, child: Consumer<ChangePage>(builder: (context, changePage, child) {
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
                    MaterialPageRoute(builder: (context) => const AddScreen()));
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
