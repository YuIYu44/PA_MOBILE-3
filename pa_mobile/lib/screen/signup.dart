import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'widget.dart';

class signup extends StatefulWidget {
  State<signup> createState() => _signup();
}

class _signup extends State<signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
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
                        CupertinoIcons.person_crop_circle_badge_plus,
                        size: 120,
                      ),
                    ),
                    texts(context, "Sign Up", 27, TextAlign.center),
                    textfields(context, emailController, false, 'Email', 14,
                        0.06, 0.6),
                    textfields(context, usernameController, false, 'Username',
                        14, 0.03, 0.6),
                    textfields(context, passwordController, true, 'Password',
                        14, 0.03, 0.6),
                    button(context, 'Sign Up', 0.05, 0, 0.35, () {
                      //sign up => database
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => login()));
                    }),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.08),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        login()));
                          },
                          child: texts(context, "I already have an account", 15,
                              TextAlign.left)),
                    ),
                  ],
                ),
              )),
        ]))));
  }
}
