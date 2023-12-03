// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/provider/change_page.dart';
import 'package:pa_mobile/provider/change_theme.dart';
import 'package:pa_mobile/provider/fav_clothes.dart';
import 'package:pa_mobile/services/admin_service.dart';
import 'package:pa_mobile/services/storage.dart';
import 'package:pa_mobile/services/user_service.dart';
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

  home({super.key});

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
                    icon: const Icon(CupertinoIcons.moon, size: 30),
                    onPressed: () {
                      Provider.of<CustomTheme>(context, listen: false)
                          .preferenced(1);
                    }),
              ),
              FutureBuilder(
                  future: Storage().get_link("carousel"),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData &&
                          snapshot.data![0].toString().isNotEmpty) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: CarouselSlider.builder(
                            itemCount: snapshot.data![0].length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    int pageViewIndex) =>
                                Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data![0][itemIndex]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              autoPlay: true,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              viewportFraction: 0.8,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          color: ThemeData().scaffoldBackgroundColor,
                        );
                      }
                    }
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  }),
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.05),
                  width: MediaQuery.of(context).size.width * 0.93,
                  child: category(context, category_atasan)),
              category(context, category_bawahan),
            ])));
  }

  Widget favorite(BuildContext context) {
    return Padding(
        padding: customEdgeInsets(context, 0.03, 0.02),
        child: ChangeNotifierProvider<fav_clothes>(
            create: (context) => fav_clothes(),
            child: Consumer<fav_clothes>(builder: (context, data, __) {
              return FutureBuilder(
                  future: data.add([
                    {"kk": "kk"}
                  ]),
                  builder: (BuildContext context, snapshot) {
                    return FutureBuilder(
                      future: userservice().favoriteContent(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData && snapshot.data.length > 0) {
                            data.add(snapshot.data);
                            return ListView.builder(
                              itemCount: data.favorite.length,
                              itemBuilder: (context, index) {
                                String productId =
                                    data.favorite[index].keys.first;
                                final key = data.favorite[index][productId];

                                return Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: FutureBuilder(
                                    future: adminServices()
                                        .retrievecertainProduct(productId, key),
                                    builder: (context, productSnapshot) {
                                      if (productSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (productSnapshot.hasError) {
                                        return Text(
                                            'Error: ${productSnapshot.error}');
                                      } else if (!productSnapshot.hasData ||
                                          !productSnapshot.data!.exists) {
                                        userservice()
                                            .deletefavorite(productId, key);
                                        data.deleteproduct(productId);
                                        return const Text("");
                                      } else {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: FutureBuilder(
                                                future: Storage().getImage(
                                                    "product/${productSnapshot.data!.get('kategori')}/$productId.${productSnapshot.data!.get('ekstensi')}"),
                                                builder: (context, snapshot2) {
                                                  return (snapshot2.hasData &&
                                                          snapshot2
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done)
                                                      ? Image.network(
                                                          snapshot2.data!,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Container();
                                                },
                                              ),
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.58,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5, bottom: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10,
                                                                    bottom: 5),
                                                            child: texts_2(
                                                              context,
                                                              "Rp. ${productSnapshot.data!['harga']}",
                                                              18,
                                                              TextAlign.start,
                                                              FontWeight.w900,
                                                            )),
                                                        Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 5),
                                                            child: texts_2(
                                                              context,
                                                              productSnapshot
                                                                  .data!
                                                                  .get(
                                                                      'deskripsi'),
                                                              14,
                                                              TextAlign.start,
                                                              FontWeight.w600,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          await userservice()
                                                              .deletefavorite(
                                                                  productId,
                                                                  key);
                                                          data.delete(
                                                              productId);
                                                          var snackbar_ = snackbar(
                                                              context,
                                                              "Produk Berhasil Dihapus Dari Daftar Favorite",
                                                              Colors.green,
                                                              2) as SnackBar;
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackbar_);
                                                        },
                                                        icon: const Icon(
                                                          CupertinoIcons.trash,
                                                          size: 35,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                                child: texts_2(
                                    context,
                                    "Tidak Ada Produk Favorite",
                                    15,
                                    TextAlign.center,
                                    FontWeight.bold));
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  });
            })));
  }

  Widget info(BuildContext context) {
    return Padding(
        padding: customEdgeInsets(context, 0.03, 0.02),
        child: FutureBuilder(
            future: Storage().get_link("info"),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data.toString().isNotEmpty) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data![0].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: 20,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.05),
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.35,
                            child: ClipOval(
                              child: Image.network(
                                snapshot.data![0][index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.2,
                              child: texts_2(context, snapshot.data![1][index],
                                  20, TextAlign.start, FontWeight.bold))
                        ]);
                      });
                } else {
                  return Container(
                    color: ThemeData().scaffoldBackgroundColor,
                  );
                }
              }
              return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: const Center(child: CircularProgressIndicator()));
            }));
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: texts_2(context, "Konfirmasi Logout",
                                      20, TextAlign.start, FontWeight.normal),
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
                          })
                        ],
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
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
    return ChangeNotifierProvider<ChangePage>(
        create: (context) => ChangePage(),
        child: WillPopScope(onWillPop: () {
          return Future.value(false);
        }, child: Consumer<ChangePage>(builder: (context, changePage, child) {
          return Scaffold(
              appBar: appbar(context),
              body: pages[changePage.selects],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                unselectedItemColor: Theme.of(context).iconTheme.color,
                selectedItemColor: Theme.of(context).cardColor,
                currentIndex: changePage.selects,
                onTap: (index) {
                  changePage.change(index);
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const [
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
