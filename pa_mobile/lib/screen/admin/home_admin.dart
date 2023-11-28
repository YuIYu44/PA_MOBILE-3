// ignore_for_file: camel_case_types

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

import '../../services/product.dart';

class home_admin extends StatefulWidget {
  const home_admin({super.key});

  @override
  State<home_admin> createState() => _home_adminState();
}

class _home_adminState extends State<home_admin> {
  Future<List<Product>>? prodList;
  List<Product>? retrievedProdList;

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
                if (snapshot.connectionState == ConnectionState.done) {
                return (snapshot.hasData)
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Map<String, dynamic>> dat = snapshot.data!.docs[index];

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
                                          "product/${dat.id}.${dat.get('ekstensi')}"),
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
                                                "Rp. ${dat.get('harga')}",
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

                                                // ----------------- UBAH NANTI ------------------delete

                                                FirebaseFirestore.instance
                                                    .collection("product")
                                                    .doc(dat.id)
                                                    .delete();

                                                final desertRef = FirebaseStorage
                                                    .instance
                                                    .ref()
                                                    .child(
                                                        "product/${dat.id}.${dat.get('ekstensi')}");

                                                await desertRef.delete();

                                                setState(() {});

                                                // ----------------- UBAH NANTI ------------------delete

                                              },
                                              icon: const Icon(
                                                CupertinoIcons.trash,
                                                size: 35,
                                              )),
                                          IconButton(
                                              onPressed: () {

                                                // ----------------- UBAH NANTI ------------------edit

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditScreen(prod: Product(
                                                              id: dat.id,
                                                              harga: int.parse(dat.get('harga')),
                                                              desc: dat.get('deskripsi'),
                                                              ekstensi: dat.get('ekstensi'),
                                                              kategori: dat.get('kategori')
                                                              ),
                                                            )
                                                    )
                                                );

                                                // ----------------- UBAH NANTI ------------------edit

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
                    : const Text("");
                  } else{
                    return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: const Center(child: CircularProgressIndicator()));
                  }
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
                        title: texts_2(context, "Konfirmasi Logout", 20,
                            TextAlign.start, FontWeight.normal),
                        content: texts_2(
                            context,
                            "Apakah Anda Yakin Ingin Logout ?",
                            16,
                            TextAlign.start,
                            FontWeight.normal),
                        backgroundColor: Theme.of(context).cardColor,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: texts_2(context, "Batal", 16,
                                TextAlign.start, FontWeight.normal),
                          ),
                          TextButton(
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: texts_2(context, "Logout", 16,
                                TextAlign.start, FontWeight.normal),
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
