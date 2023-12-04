import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa_mobile/model/product.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/services/admin_service.dart';
import 'package:pa_mobile/services/storage.dart';

class EditScreen extends StatefulWidget {
  final prodservices = AdminServices();
  final Product prod;
  EditScreen({super.key, required this.prod});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  XFile? _img;
  final _picker = ImagePicker();
  bool _loading = false;

  @override
  Widget build(BuildContext ctx) {
    _hargaController.text = (_hargaController.text == "")
        ? widget.prod.harga.toString()
        : _hargaController.text;
    _descController.text =
        (_descController.text == "") ? widget.prod.desc : _descController.text;

    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: appbar(ctx),
        body: SingleChildScrollView(
          child: Padding(
            padding: customEdgeInsets(ctx, 0.03, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    right: MediaQuery.sizeOf(ctx).width * 0.7,
                    bottom: 20,
                  ),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.back, size: 35),
                    onPressed: () {
                      if (!_loading) {
                        ScaffoldMessenger.of(ctx).clearSnackBars();
                        Navigator.of(ctx).pop(0);
                      } else {
                        final snackBar = snackbar(ctx, "Mohon tunggu sebentar",
                            Colors.orangeAccent, 2) as SnackBar;
                        ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                      }
                    },
                  ),
                ),
                GestureDetector(
                  child: Container(
                      width: MediaQuery.of(ctx).size.width * 0.47,
                      height: MediaQuery.of(ctx).size.width * 0.6,
                      decoration: (_img != null)
                          ? BoxDecoration(
                              color: Theme.of(ctx).cardColor,
                              image: DecorationImage(
                                  image: FileImage(File(_img!.path))))
                          : null,
                      child: (_img == null)
                          ? SizedBox(
                              width: MediaQuery.of(ctx).size.width * 0.37,
                              height: 150,
                              child: FutureBuilder<String>(
                                  future: Storage().getImage(
                                      "product/${widget.prod.kategori}/${widget.prod.id}.${widget.prod.ekstensi}"),
                                  builder:
                                      (ctx, AsyncSnapshot<String> snapshot2) {
                                    return (snapshot2.hasData)
                                        ? Image.network(
                                            snapshot2.data!,
                                            fit: BoxFit.contain,
                                          )
                                        : Container();
                                  }),
                            )
                          : null),
                  onTap: () async {
                    final image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      _img = image;
                    });
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: textfields(
                    ctx,
                    _hargaController,
                    false,
                    "Harga",
                    14,
                    0,
                    0.4,
                  ),
                ),
                Container(
                  child: textform(
                      ctx, _descController, "Deskripsi", 14, 0.05, 0.4),
                ),
                Container(
                  child: button(ctx, "Ubah", 0.03, 0.2, 0.45, () async {
                    if (_hargaController.text != "" &&
                        _descController.text != "") {
                      int hargaProd = 0;

                      try {
                        hargaProd = int.parse(_hargaController.text);
                      } catch (e) {
                        final snackBar = snackbar(
                            ctx,
                            "Harga yang dimasukkan invalid",
                            Colors.red,
                            2) as SnackBar;
                        ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                        return;
                      }

                      if (hargaProd <= 0) {
                        final snackBar = snackbar(
                            ctx,
                            "Harga tidak boleh kurang dari atau sama dengan 0",
                            Colors.red,
                            2) as SnackBar;
                        ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                        return;
                      }

                      _loading = true;

                      widget.prod.harga = hargaProd;
                      widget.prod.desc = _descController.text;
                      if (_img != null) {
                        widget.prod.ekstensi = _img!.path.split(".").last;
                      }

                      await widget.prodservices
                          .updateData(ctx, _img, widget.prod)
                          .then((value) => _loading = false);
                    } else {
                      // Jaga-jaga
                      final snackBar = snackbar(
                          ctx,
                          "Mohon isi semua data yang dibutuhkan",
                          Colors.red,
                          2) as SnackBar;
                      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
