import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';

class chosen_clothes extends StatelessWidget {
  final String kind;
  chosen_clothes(this.kind, {super.key});

  final List<List<String>> member = [
    [
      "assets/place.png",
      "assets/time.png",
      "assets/diskon.png",
      "assets/3THRIFT.png"
    ],
    ["Ibnu Yafi", "Hadie Pratama", "Agustina Dwi", "Ayu Lestari"]
  ];

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
                child: Stack(children: [
                  Positioned(
                      top: 0,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.back, size: 35),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                  Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.07,
                      child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.94,
                          height: 50,
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: texts_2(context, kind, 25, TextAlign.left,
                              FontWeight.bold))),
                  Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.16,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: member[0].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Row(children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: Image.asset(
                                          member[0][index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Row(children: [
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Column(children: [
                                              texts_2(
                                                  context,
                                                  "Rp ${member[1][index]}",
                                                  16,
                                                  TextAlign.start,
                                                  FontWeight.bold), //harga
                                              texts_2(
                                                  context,
                                                  "keterangan",
                                                  13,
                                                  TextAlign.start,
                                                  FontWeight.normal)
                                            ])),

                                        IconButton(
                                            onPressed: () {
                                              _isTap = !_isTap;
                                            },
                                            icon: Icon(
                                                CupertinoIcons.heart_fill,
                                                size: 35,
                                                color: _isTap
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .cardColor)), //add to favorite => database
                                      ])
                                    ]));
                              })))
                ]))));
  }
}
