import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/widget.dart';

class changepass extends StatefulWidget {
  State<changepass> createState() => _changepass();
}

class _changepass extends State<changepass> {
  final TextEditingController oldController = TextEditingController();
  final TextEditingController newController = TextEditingController();
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
                    child: Center(
                      child: Column(children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: 10,
                                right: MediaQuery.sizeOf(context).width * 0.7),
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(CupertinoIcons.back, size: 35),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                        textfields(context, oldController, true, 'Old Password',
                            14, 0.06, 0.65),
                        textfields(context, newController, true, 'New Password',
                            14, 0.03, 0.65),
                        button(context, 'Change Password', 0.05, 0, 0.65,
                            () {}), //ini ubah password
                      ]),
                    )))));
  }
}
