import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';

class chosen_clothes extends StatelessWidget {
  final String kind;
  chosen_clothes(this.kind, {super.key});

  Future<String> _getImage(photoPath) async {
    final ref = FirebaseStorage.instance.ref().child(photoPath);
    String url = await ref.getDownloadURL();
    return url;
  }

  final category_atasan = {
    'OUTER': ["Cardigan", "Jaket"],
    'WARM': ["Sweater", "Hoodie"],
    'INNER': ["Kemeja", "Kaos"],
  };
  final category_bawahan = {
    'CELANA': ["Jeans", "Short"],
  };

  bool _isTap =
      false; //heart change after futurebuild database of user favorite

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

                      // Define the selected category (change this based on your logic)
                      String selectedCategory = kind
                          .toLowerCase(); // Change this to the desired category

                      // Filter products based on the selected category and items
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
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: FutureBuilder<String>(
              future:
                  _getImage("product/${product.id}.${product.get('ekstensi')}"),
              builder: (context, AsyncSnapshot<String> snapshot2) {
                return (snapshot2.hasData)
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
                      ), //harga
                      texts_2(
                        context,
                        product.get('deskripsi'),
                        13,
                        TextAlign.start,
                        FontWeight.normal,
                      ),
                    ],
                  ),
                ), //keterangan
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // FutureBuilder<User?>(
                    //   future: FirebaseAuth.instance.authStateChanges().first,
                    //   builder: (context, userSnapshot) {
                    //     if (userSnapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return CircularProgressIndicator();
                    //     }

                    //     if (userSnapshot.hasError) {
                    //       return Text("Error: ${userSnapshot.error}");
                    //     }

                    //     User? user = userSnapshot.data;

                    //     return FutureBuilder<DocumentSnapshot>(
                    //       future: FirebaseFirestore.instance
                    //           .collection("users")
                    //           .doc(user?.email)
                    //           .get(),
                    //       builder: (context, userDocSnapshot) {
                    //         if (userDocSnapshot.connectionState ==
                    //             ConnectionState.waiting) {
                    //           return CircularProgressIndicator();
                    //         }

                    //         if (userDocSnapshot.hasError) {
                    //           return Text("Error: ${userDocSnapshot.error}");
                    //         }

                    //         // Extract favorites data from the user's doc
                    //         List<dynamic> favorites =
                    //             userDocSnapshot.data?.get('favorites') ?? [];

                    //         return FutureBuilder<QuerySnapshot>(
                    //           future: FirebaseFirestore.instance
                    //               .collection("product")
                    //               .get(),
                    //           builder: (BuildContext context, productSnapshot) {
                    //             if (productSnapshot.connectionState ==
                    //                 ConnectionState.waiting) {
                    //               return CircularProgressIndicator();
                    //             }

                    //             if (productSnapshot.hasError) {
                    //               return Text(
                    //                   "Error: ${productSnapshot.error}");
                    //             }

                    //             // Extract product data from the snapshot
                    //             List<DocumentSnapshot> products =
                    //                 productSnapshot.data!.docs;

                    //             return IconButton(
                    //               onPressed: () async {
                    //                 _isTap = !_isTap;
                    //                 if (user != null) {
                    //                   // Get the ID of the current product
                    //                   String productId =
                    //                       productSnapshot.data!.docs as String;

                    //                   // Check if the product is already in favorites
                    //                   if (!favorites.contains(productId)) {
                    //                     // Reference to the user's document in Firestore
                    //                     var userDocRef = FirebaseFirestore
                    //                         .instance
                    //                         .collection("users")
                    //                         .doc(user.email);

                    //                     // Update the user's document to add the product to the favorites field
                    //                     await userDocRef.update({
                    //                       'favorites': FieldValue.arrayUnion(
                    //                           [productId]),
                    //                     });

                    //                     // Show a notification to indicate that the product has been added to favorites
                    //                     showAlertDialog(
                    //                         context,
                    //                         "Pemberitahuan",
                    //                         "Produk Favorit Berhasil Ditambahkan",
                    //                         exit: false);
                    //                   } else {
                    //                     // Product is already in favorites, handle accordingly
                    //                     showAlertDialog(
                    //                         context,
                    //                         "Pemberitahuan",
                    //                         "Produk sudah ada di favorit",
                    //                         exit: false);
                    //                   }
                    //                 }
                    //               },
                    //               icon: Icon(
                    //                 CupertinoIcons.heart_fill,
                    //                 size: 35,
                    //                 color: favorites.contains(productSnapshot
                    //                         .data!.docs as String)
                    //                     ? Colors.red
                    //                     : Theme.of(context).cardColor,
                    //               ),
                    //             );
                    //           },
                    //         );
                    //       },
                    //     );
                    //   },
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
