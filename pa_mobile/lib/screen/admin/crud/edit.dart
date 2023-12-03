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

  @override
  Widget build(BuildContext context) {
    // --------------- UBAH NANTI (ketika sudah cerdas) ----------------
    _hargaController.text = (_hargaController.text == "")
        ? widget.prod.harga.toString()
        : _hargaController.text;
    _descController.text =
        (_descController.text == "") ? widget.prod.desc : _descController.text;
    // --------------- UBAH NANTI (ketika sudah cerdas) ----------------

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                GestureDetector(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.47,
                      height: MediaQuery.of(context).size.width * 0.6,
                      decoration: (_img != null)
                          ? BoxDecoration(
                              color: Theme.of(context).cardColor,
                              image: DecorationImage(
                                  image: FileImage(File(_img!.path))))
                          : null,
                      child: (_img == null)
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.37,
                              height: 150,
                              child: FutureBuilder<String>(
                                  future: Storage().getImage(
                                      "product/${widget.prod.kategori}/${widget.prod.id}.${widget.prod.ekstensi}"),
                                  builder: (context,
                                      AsyncSnapshot<String> snapshot2) {
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
                    context,
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
                      context, _descController, "Deskripsi", 14, 0.05, 0.4),
                ),
                Container(
                  child: button(context, "Ubah", 0.03, 0.2, 0.45, () async {
                    widget.prod.harga = int.parse(_hargaController.text);
                    widget.prod.desc = _descController.text;
                    if (_img != null) {
                      widget.prod.ekstensi = _img!.path.split(".").last;
                    }

                    await widget.prodservices
                        .updateData(context, _img, widget.prod);
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
