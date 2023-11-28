import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../screen/widget.dart';

class Product {
  String? id;
  int harga;
  String desc;
  String kategori;
  String ekstensi;

  CollectionReference productCol =
      FirebaseFirestore.instance.collection("product");

  Product(
      {this.id,
      required this.harga,
      required this.desc,
      required this.ekstensi,
      required this.kategori});

  Map<String, dynamic> toMap() {
    return {
      'harga': harga.toString(),
      'deskripsi': desc,
      'kategori': kategori,
      'ekstensi': ekstensi
    };
  }

  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        harga = int.parse(doc.data()!["harga"]),
        desc = doc.data()!["deskripsi"],
        kategori = doc.data()!["kategori"],
        ekstensi = doc.data()!["kategori"];


  Future<List<Product>> retrieveProduct() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("product").get();
    return snapshot.docs
        .map((docSnapshot) => Product.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<String> getImageUrl() async {
    final ref =
        FirebaseStorage.instance.ref().child("product/${id!}.$ekstensi");
    String url = await ref.getDownloadURL();

    return url;
  }

  Future addData(BuildContext context, XFile pic) async {
    DocumentReference newProduct = await productCol.add(toMap());

    await FirebaseStorage.instance
        .ref()
        .child('product/${newProduct.id}.${pic.path.split(".").last}')
        .putFile(File(pic.path))
        .then((value1) {
      showAlertDialog(context, "Pemberitahuan", "Produk Berhasil Ditambahkan",
          exit: true);
    });
  }

  updateData(BuildContext context, XFile? pic) async {
    await productCol.doc(id).update(toMap());

    if(pic != null) {
    await FirebaseStorage.instance
        .ref()
        .child('product/$id.${pic.path.split(".").last}')
        .putFile(File(pic.path));
    }
  }

}
