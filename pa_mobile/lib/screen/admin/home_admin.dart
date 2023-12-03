// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/model/product.dart';
import 'package:pa_mobile/provider/dropdownbutton.dart';
import 'package:pa_mobile/provider/show_clothes.dart';
import 'package:pa_mobile/screen/admin/crud/add.dart';
import 'package:pa_mobile/screen/admin/crud/edit.dart';
import 'package:pa_mobile/provider/change_page.dart';
import 'package:pa_mobile/provider/change_theme.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/services/admin_service.dart';
import 'package:pa_mobile/services/storage.dart';
import 'package:provider/provider.dart';

class home_admin extends StatelessWidget {
  const home_admin({super.key});

  Widget home(BuildContext context) {
    var adminsrv = adminServices();
    return Padding(
        padding: customEdgeInsets(context, 0.03, 0),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<show_clothes>(
                  create: (_) => show_clothes()),
              ChangeNotifierProvider<categoryclothes>(
                  create: (_) => categoryclothes()),
            ],
            child: Consumer<show_clothes>(builder: (context, dataclothes, __) {
              return Consumer<categoryclothes>(
                  builder: (context, categoryclothes, __) {
                return FutureBuilder(
                    future: dataclothes.add([]),
                    builder: (BuildContext context, snapshot) {
                      return FutureBuilder(
                        future: adminsrv
                            .retrieveProduct(categoryclothes.getCategory),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            dataclothes.add(snapshot.data);
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.8),
                                    child: IconButton(
                                      icon: const Icon(CupertinoIcons.moon,
                                          size: 30),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Provider.of<CustomTheme>(context,
                                                listen: false)
                                            .preferenced(1);
                                      },
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                        dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        )),
                                        value: categoryclothes.getCategory,
                                        items: <String>[
                                          "Cardigan",
                                          "Jaket",
                                          "Sweater",
                                          "Hoodie",
                                          "Kemeja",
                                          "Kaos",
                                          "Jeans",
                                          "Short"
                                        ].map((String val) {
                                          return DropdownMenuItem<String>(
                                              value: val,
                                              child: texts_2(
                                                context,
                                                val,
                                                15,
                                                TextAlign.left,
                                                FontWeight.normal,
                                              ));
                                        }).toList(),
                                        onChanged: (String? value) {
                                          categoryclothes
                                              .changecategory(value!);
                                        },
                                      ))),
                                  Expanded(
                                    child: FutureBuilder(
                                      future: adminServices().retrieveProduct(
                                          categoryclothes.getCategory),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return (snapshot.hasData &&
                                                  snapshot.data!.isNotEmpty)
                                              ? ListView.builder(
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Product dat =
                                                        snapshot.data![index];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                            child: FutureBuilder<
                                                                    String>(
                                                                future: Storage()
                                                                    .getImage(
                                                                        "product/${dat.kategori}/${dat.id}.${dat.ekstensi}"),
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            String>
                                                                        snapshot2) {
                                                                  return (snapshot2
                                                                          .hasData)
                                                                      ? Image
                                                                          .network(
                                                                          snapshot2
                                                                              .data!,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        )
                                                                      : Container();
                                                                }),
                                                          ),
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.35,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.58,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Theme.of(
                                                                      context)
                                                                  .cardColor,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.35,
                                                                  child: Column(
                                                                    children: [
                                                                      texts_2(
                                                                          context,
                                                                          "Rp. ${dat.harga}",
                                                                          16,
                                                                          TextAlign
                                                                              .start,
                                                                          FontWeight
                                                                              .bold), //harga
                                                                      texts_2(
                                                                          context,
                                                                          snapshot
                                                                              .data![
                                                                                  index]
                                                                              .desc,
                                                                          13,
                                                                          TextAlign
                                                                              .start,
                                                                          FontWeight
                                                                              .normal)
                                                                    ],
                                                                  ),
                                                                ), //keterangan
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        bool
                                                                            deleteConfirmed =
                                                                            await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: texts_2(context, "Konfirmasi Hapus", 20, TextAlign.start, FontWeight.normal),
                                                                              content: texts_2(context, "Apakah Anda Yakin Ingin Menghapus Item Ini ?", 16, TextAlign.start, FontWeight.normal),
                                                                              backgroundColor: Theme.of(context).cardColor,
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop(false);
                                                                                  },
                                                                                  child: texts_2(context, "Batal", 16, TextAlign.start, FontWeight.bold),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () async {
                                                                                    Navigator.of(context).pop(true);
                                                                                  },
                                                                                  child: texts_2(context, "Hapus", 16, TextAlign.start, FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );

                                                                        // Hapus data jika pengguna mengonfirmasi
                                                                        if (deleteConfirmed) {
                                                                          adminsrv.deleteData(
                                                                              context,
                                                                              dat);
                                                                          Storage()
                                                                              .deleteImage("product/${dat.kategori}/${dat.id}.${dat.ekstensi}");
                                                                          dataclothes
                                                                              .delete([
                                                                            dat.id,
                                                                            dat.kategori
                                                                          ]);
                                                                        }
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        CupertinoIcons
                                                                            .trash,
                                                                        size:
                                                                            35,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(MaterialPageRoute(
                                                                                builder: (context) => EditScreen(
                                                                                      prod: Product(id: dat.id, harga: dat.harga, desc: dat.desc, ekstensi: dat.ekstensi, kategori: dat.kategori),
                                                                                    )))
                                                                            .then((value) => categoryclothes.changecategory(categoryclothes.getCategory));
                                                                      },
                                                                      icon: const Icon(
                                                                          CupertinoIcons
                                                                              .pen,
                                                                          size:
                                                                              35),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  })
                                              : Center(
                                                  child: texts_2(
                                                  context,
                                                  "Tidak Ada Produk",
                                                  15,
                                                  TextAlign.center,
                                                  FontWeight.bold,
                                                ));
                                        } else {
                                          return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              child: const Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                        }
                                      },
                                    ),
                                  ),
                                ]);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    });
              });
            })));
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
                                TextAlign.start, FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: texts_2(context, "Logout", 16,
                                TextAlign.start, FontWeight.bold),
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
              onPressed: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const AddScreen()))
                    .then((_) => changePage.change(changePage.selects));
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
