// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/services/storage.dart';
import 'package:pa_mobile/services/user_service.dart';

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

  bool _isTap = false;

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
                  width: MediaQuery.sizeOf(context).width * 0.94,
                  height: 50,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: texts_2(
                    context,
                    kind,
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
                    future:
                        FirebaseFirestore.instance.collection("product").get(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      // Memilih kategori
                      String selectedCategory = kind.toLowerCase();

                      // Filter produk berdasarkan kategori dan item yang dipilih
                      var filteredProducts = snapshot.data!.docs
                          .where((doc) =>
                              doc.get('kategori').toString().toLowerCase() ==
                              selectedCategory.toLowerCase())
                          .toList();

                      return (filteredProducts.isNotEmpty)
                          ? ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                return buildProductCard(
                                    filteredProducts[index], context);
                              },
                            )
                          : const Text("Produk yang anda pilih tidak ada");
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

  Widget buildProductCard(DocumentSnapshot product, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: FutureBuilder<String>(
              future: Storage()
                  .getImage("product/${product.id}.${product.get('ekstensi')}"),
              builder: (context, snapshot2) {
                return (snapshot2.hasData &&
                        snapshot2.connectionState == ConnectionState.done)
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
                            "Rp. ${product.get('harga')}",
                            16,
                            TextAlign.start,
                            FontWeight.bold,
                          ),
                          texts_2(
                            context,
                            product.get('deskripsi'),
                            13,
                            TextAlign.start,
                            FontWeight.normal,
                          ),
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
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (productSnapshot.hasError) {
                                    return Text(
                                        "Error: ${productSnapshot.error}");
                                  }

                                  // Extract product data from the snapshot
                                  List<DocumentSnapshot> products =
                                      productSnapshot.data!.docs;

                                  return IconButton(
                                    onPressed: () async {
                                      _isTap = !_isTap;

                                      //   if (user != null) {
                                      //     userservice().addfavorite(
                                      //          product.id);

                                      //     // Menampilkan notifikasi bahwa produk berhasil ditambahkan ke favorite
                                      //     showAlertDialog(
                                      //         context,s
                                      //         "Pemberitahuan",
                                      //         "Produk Favorit Berhasil Ditambahkan",
                                      //         exit: false);
                                      //   } else {
                                      //     // Menampilkan notifikasi bahwa produk sudah ada di favorite
                                      //     showAlertDialog(
                                      //         context,
                                      //         "Pemberitahuan",
                                      //         "Produk sudah ada di favorit",
                                      //         exit: false);
                                      //   }
                                    },
                                    icon: Icon(CupertinoIcons.heart_fill,
                                        size: 35,
                                        color: favoriteSnapshot.data == null
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : favoriteSnapshot.data.contains(
                                                    product.id as String)
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                  );
                                },
                              );
                            },
                          )
                        ])
                  ]))
        ]));
  }
}
