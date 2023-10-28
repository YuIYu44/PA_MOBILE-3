import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/admin/home_admin.dart';
import 'package:pa_mobile/screen/login.dart';
import 'widget.dart';

class welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/3THRIFT.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * 0.05,
                        bottom: MediaQuery.sizeOf(context).height * 0.03),
                    child: texts(
                        context, "WELCOME TO 3THRIFT", 27, TextAlign.center)),
                texts(context, "Let's Check Our Collections", 18,
                    TextAlign.center),
                button(context, "Sign In", 0.05, 0, 0.4, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => login()));
                }),
              ],
            ),
          ),
        ));
  }
}
