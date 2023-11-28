import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/provider/change_page.dart';
import 'package:pa_mobile/provider/change_theme.dart';
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
  final List<String> member = [
    "assets/place.png",
    "assets/time.png",
    "assets/diskon.png",
    "assets/3THRIFT.png"
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
        child: FutureBuilder(
          future: userservice().favoriteContent(),
          builder: (BuildContext context, snapshot) {
            return (snapshot.hasData)
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String productId = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("product")
                              .doc(productId)
                              .get(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (productSnapshot.hasError) {
                              return Text('Error: ${productSnapshot.error}');
                            } else if (!productSnapshot.hasData ||
                                !productSnapshot.data!.exists) {
                              userservice().deletefavorite(productId);
                              return Container();
                            } else {
                              return (productSnapshot.hasData)
                                  ? Row(
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
                                                "product/$productId.${productSnapshot.data!.get('ekstensi')}"),
                                            builder: (context, snapshot2) {
                                              return (snapshot2.hasData &&
                                                      snapshot2
                                                              .connectionState ==
                                                          ConnectionState.done)
                                                  ? Image.network(
                                                      snapshot2.data!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container();
                                            },
                                          ),
                                        ),
                                        Container(
                                          color: Theme.of(context).cardColor,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.58,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                child: Column(
                                                  children: [
                                                    texts_2(
                                                        context,
                                                        "Rp. ${productSnapshot.data!.get('harga')}",
                                                        16,
                                                        TextAlign.start,
                                                        FontWeight.bold),
                                                    texts_2(
                                                        context,
                                                        productSnapshot.data!
                                                            .get('deskripsi'),
                                                        13,
                                                        TextAlign.start,
                                                        FontWeight.normal)
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
                                                      userservice()
                                                          .deletefavorite(
                                                              productId);
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
                                    )
                                  : const CircularProgressIndicator();
                            }
                            ;
                          },
                        ),
                      );
                    },
                  )
                : const Text("Tidak Ada Produk Favorite");
          },
        ));
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
                            FirebaseAuth.instance.signOut();
                          })
                        ],
                      );
                    }
                  }
                  return Container(
                    color: ThemeData().scaffoldBackgroundColor,
                    child: const Center(child: CircularProgressIndicator()),
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
                onTap: (_index) {
                  changePage.change(_index);
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home, size: 35), label: "Home"),
                  const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.heart, size: 35),
                      label: "favorite"),
                  const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.info, size: 35), label: "Info"),
                  const BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.profile_circled, size: 35),
                      label: "Profile"),
                ],
              ));
        })));
  }
}
