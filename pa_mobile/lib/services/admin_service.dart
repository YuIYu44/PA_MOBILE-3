// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa_mobile/model/product.dart';
import '../screen/widget.dart';

class adminServices {
  CollectionReference productCol =
      FirebaseFirestore.instance.collection("product");

  Future<DocumentSnapshot> retrievecertainProduct(id_, kind) async {
    var snapshot =
        await productCol.doc("products").collection(kind).doc(id_).get();
    return snapshot;
  }

  Future<List<Product>> retrieveProduct(kind) async {
    var collection_exist =
        await productCol.doc("products").collection(kind).limit(1).get();
    QuerySnapshot<Map<String, dynamic>> snapshot = await productCol
        .doc("products")
        .collection(kind)
        .get() as QuerySnapshot<Map<String, dynamic>>;
    if (collection_exist.docs.isNotEmpty) {
      return snapshot.docs
          .map((docSnapshot) => Product(
              id: docSnapshot.id,
              harga: int.parse(docSnapshot.data()["harga"]),
              desc: docSnapshot.data()["deskripsi"],
              ekstensi: docSnapshot.data()["ekstensi"],
              kategori: docSnapshot.data()["kategori"]))
          .toList();
    }
    return [];
  }

  Future addData(BuildContext context, XFile pic, Product product) async {
    DocumentReference newProduct = await productCol
        .doc("products")
        .collection(product.kategori)
        .add(product.toMap());

    await FirebaseStorage.instance
        .ref()
        .child(
            'product/${product.kategori}/${newProduct.id}.${pic.path.split(".").last}')
        .putFile(File(pic.path))
        .then((value1) {
      final snackBar =
          snackbar(context, "Produk Berhasil Ditambahkan", Colors.green, 2)
              as SnackBar;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  updateData(BuildContext contexts, XFile? pic, Product product) async {
    await productCol
        .doc("products")
        .collection(product.kategori)
        .doc(product.id)
        .update(product.toMap())
        .then((value1) async {});
    if (pic != null) {
      await FirebaseStorage.instance
          .ref()
          .child(
              'product/${product.kategori}/${product.id}.${pic.path.split(".").last}')
          .putFile(File(pic.path));
    }
    final snackBar =
        snackbar(contexts, "Produk Berhasil Diubah", Colors.green, 1)
            as SnackBar;
    ScaffoldMessenger.of(contexts).showSnackBar(snackBar);
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(contexts).pop();
  }

  deleteData(BuildContext context, Product product) async {
    await productCol.doc("products/${product.kategori}/${product.id}").delete();
  }
}
