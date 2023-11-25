import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa_mobile/screen/widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  XFile? _img;
  final _picker = ImagePicker();

  String selectedCategory = "";

  List<Map<String, String>> items = [
    {"name": "Celana"},
    {"name": "Baju"},
    {"name": "Hoodie"},
    {"name": "Sweater"},
    {"name": "Jaket"},
    {"name": "Topi"},
  ];

  @override
  Widget build(BuildContext context) {
    CollectionReference product =
        FirebaseFirestore.instance.collection("product");

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: appbar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: customEdgeInsets(context, 0.03, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    right: MediaQuery.sizeOf(context).width * 0.7,
                    bottom: 20,
                  ),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.back, size: 35),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: MediaQuery.sizeOf(context).width * 0.04,
                        ),
                        width: MediaQuery.of(context).size.width * 0.47,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            image: (_img != null)
                                ? DecorationImage(
                                    image: FileImage(File(_img!.path)))
                                : null),
                      ),
                      onTap: () async {
                        final image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        setState(() {
                          _img = image;
                        });
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: textfields(
                              context,
                              hargaController,
                              false,
                              "Harga",
                              14,
                              0,
                              0.4,
                            ),
                          ),
                          Container(
                            child: textform(
                              context,
                              descController,
                              "Deskripsi",
                              14,
                              0.05,
                              0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRadioTile(items[0]),
                    buildRadioTile(items[1]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRadioTile(items[2]),
                    buildRadioTile(items[3]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRadioTile(items[4]),
                    buildRadioTile(items[5]),
                  ],
                ),
                Container(
                  child: button(context, "Add", 0.03, 0.2, 0.25, () async {
                    DocumentReference newProduct = await product.add({
                      'harga': hargaController.text,
                      'kategori': selectedCategory,
                      'deskripsi': descController.text,
                      'ekstensi': _img!.path.split(".").last
                    });

                    await FirebaseStorage.instance
                        .ref()
                        .child(
                            'product/${newProduct.id}.${_img!.path.split(".").last}')
                        .putFile(File(_img!.path))
                        .then((value1) {
                      showAlertDialog(context, "Pemberitahuan",
                          "Produk Berhasil Ditambahkan", exit: true);
                    });
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadioTile(Map<String, String> item) {
    return Row(
      children: [
        Radio(
          value: item["name"],
          groupValue: selectedCategory,
          onChanged: (value) {
            setState(() {
              selectedCategory = value.toString();
            });
          },
        ),
        Text(item["name"]!),
      ],
    );
  }
}
