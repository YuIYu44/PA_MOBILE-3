import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/screen/admin/home_admin.dart';
import 'user/home.dart';
import 'signup.dart';
import 'widget.dart';

class login extends StatefulWidget {
  State<login> createState() => _login();
}

class _login extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            body: SingleChildScrollView(
                child: Stack(children: [
          Container(
              color: Theme.of(context).cardColor,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  MediaQuery.of(context).size.height * 0.115,
                  0,
                  0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.02),
                      child: Icon(
                        CupertinoIcons.person_crop_circle,
                        size: 120,
                      ),
                    ),
                    texts(context, "Sign In", 27, TextAlign.center),
                    textfields(context, emailController, false, 'Email', 14,
                        0.06, 0.6),
                    textfields(context, passwordController, true, 'Password',
                        14, 0.03, 0.6),
                    button(context, 'Sign In', 0.05, 0, 0.35, () {
                      //sign in => database
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => home()));
                    }),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        signup()));
                          },
                          child: texts(context, "Don't have account yet?", 15,
                              TextAlign.left)),
                    ),
                  ],
                ),
              )),
        ]))));
  }
}
