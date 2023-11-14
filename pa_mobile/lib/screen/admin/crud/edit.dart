import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';

class editScreen extends StatefulWidget {
  const editScreen({super.key});

  @override
  State<editScreen> createState() => _editScreenState();
}

class _editScreenState extends State<editScreen> {
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    icon: Icon(CupertinoIcons.back, size: 35),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  width: MediaQuery.of(context).size.width * 0.37,
                  height: 150,
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
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
                      context, descController, "Deskripsi", 14, 0.05, 0.4),
                ),
                Container(
                  child: button(context, "Ubah", 0.03, 0.2, 0.45, () {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
