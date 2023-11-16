import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';

class addScreen extends StatefulWidget {
  const addScreen({super.key});

  @override
  State<addScreen> createState() => _addScreenState();
}

class _addScreenState extends State<addScreen> {
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController descController = TextEditingController();

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
                    icon: Icon(CupertinoIcons.back, size: 35),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: MediaQuery.sizeOf(context).width * 0.04,
                      ),
                      color: Theme.of(context).cardColor,
                      width: MediaQuery.of(context).size.width * 0.47,
                      height: MediaQuery.of(context).size.height * 0.3,
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
                Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.sizeOf(context).width * 0.5),
                  child: button(context, "Add", 0.03, 0.2, 0.25, () {}),
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
