// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, camel_case_types, unused_local_variable, unnecessary_cast, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/model/product.dart';
import 'package:pa_mobile/provider/Love_Clothes.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/services/admin_service.dart';
import 'package:pa_mobile/services/storage.dart';
import 'package:pa_mobile/services/user_service.dart';
import 'package:provider/provider.dart';

class chosenClothes extends StatelessWidget {
  final String kind;
  chosenClothes(this.kind, {super.key});

  final category_atasan = {
    'OUTER': ["Cardigan", "Jaket"],
    'WARM': ["Sweater", "Hoodie"],
    'INNER': ["Kemeja", "Kaos"],
  };
  final category_bawahan = {
    'CELANA': ["Jeans", "Short"],
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: appbar(context),
        body: Padding(
          padding: customEdgeInsets(context, 0.03, 0),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: IconButton(
                  icon: const Icon(CupertinoIcons.back, size: 35),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.07,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).cardColor,
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.94,
                  height: 55,
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: texts_2(
                    context,
                    kind.toUpperCase(),
                    25,
                    TextAlign.left,
                    FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.16,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                    future: adminServices().retrieveProduct(kind),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      return (snapshot.data!.isNotEmpty)
                          ? ChangeNotifierProvider<loveClothes>(
                              create: (_) => loveClothes(
                                  Theme.of(context).scaffoldBackgroundColor,
                                  snapshot.data!.length),
                              child: Consumer<loveClothes>(
                                  builder: (_, data, __) => ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        Product data = snapshot.data![index];
                                        return buildProductCard(
                                            data, context, index);
                                      })))
                          : Center(
                              child: texts_2(context, "Produk Tidak Tersedia",
                                  15, TextAlign.center, FontWeight.bold));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(Product product, BuildContext context, int index) {
    var loveClothesProvider = Provider.of<loveClothes>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: FutureBuilder<String>(
              future: Storage().getImage(
                  "product/${product.kategori}/${product.id}.${product.ekstensi}"),
              builder: (context, snapshot2) {
                return (snapshot2.hasData &&
                        snapshot2.connectionState == ConnectionState.done)
                    ? Image.network(
                        snapshot2.data!,
                        fit: BoxFit.fill,
                      )
                    : Container();
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.width * 0.35,
              width: MediaQuery.of(context).size.width * 0.58,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 5),
                              child: texts_2(
                                context,
                                "Rp. ${product.harga}",
                                18,
                                TextAlign.start,
                                FontWeight.w900,
                              )),
                          Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: texts_2(
                                context,
                                product.desc,
                                14,
                                TextAlign.start,
                                FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("product")
                                .get(),
                            builder: (BuildContext context, productSnapshot) {
                              return FutureBuilder(
                                  future: userservice().favoriteContent(),
                                  builder:
                                      (BuildContext context, favoriteSnapshot) {
                                    if (productSnapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (favoriteSnapshot.data != null) {
                                        if ((favoriteSnapshot.data.toString())
                                            .contains(product.id.toString())) {
                                          loveClothesProvider.atfavorite(
                                              index, Colors.red);
                                        }
                                      }
                                      // Extract product data from the snapshot
                                      List<DocumentSnapshot> products =
                                          productSnapshot.data!.docs;
                                      return IconButton(
                                          onPressed: () async {
                                            if (loveClothesProvider
                                                    .color(index) !=
                                                Colors.red) {
                                              userservice().addfavorite(
                                                  product.id!,
                                                  product.kategori);
                                              var snackbar_ = snackbar(
                                                  context,
                                                  "Produk Favorite Berhasil Ditambahkan",
                                                  Colors.green,
                                                  2) as SnackBar;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar_);

                                              loveClothesProvider.changelove(
                                                  index, Colors.red);
                                            } else {
                                              var snackbar_ = snackbar(
                                                  context,
                                                  "Produk sudah ada di favorite",
                                                  Colors.red,
                                                  2) as SnackBar;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar_);
                                            }
                                          },
                                          icon: Icon(CupertinoIcons.heart_fill,
                                              size: 35,
                                              color: loveClothesProvider
                                                  .color(index)));
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });
                            },
                          )
                        ])
                  ]))
        ]));
  }
}
