import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/provider/error_notification.dart';
import 'package:pa_mobile/main.dart';
import 'package:pa_mobile/services/auth.dart';
import 'package:provider/provider.dart';
import 'signup.dart';
import 'widget.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ErrorNote>(
        create: (context) => ErrorNote(),
        child: WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.height * 0.05,
                    0,
                    0),
                child: Center(child: Consumer<ErrorNote>(
                  builder: (context, error_, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.02),
                          child: const Icon(
                            CupertinoIcons.person_crop_circle,
                            size: 120,
                          ),
                        ),
                        texts(context, "Sign In", 27, TextAlign.center),
                        textfields(context, emailController, false, 'Email', 14,
                            0.06, 0.6),
                        textfields(context, passwordController, true,
                            'Password', 14, 0.03, 0.6),
                        Container(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            margin: EdgeInsets.only(
                                top: MediaQuery.sizeOf(context).height * 0.03),
                            child: texts(
                                context, error_.notif, 14, TextAlign.left)),
                        button(context, 'Sign In', 0.05, 0, 0.35, () async {
                          String login = await Auth().login(
                              emailController.value.text,
                              passwordController.value.text);
                          await error_.change(login);
                          await Future.delayed(const Duration(seconds: 1));
                          if (login == "") {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()),
                                (Route<dynamic> route) => false);
                          }
                        }),
                      ],
                    );
                  },
                )),
              ),
              Center(
                  child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.93),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SignUp()));
                    },
                    child: texts(context, "Don't have account yet?", 15,
                        TextAlign.left)),
              )),
            ])))));
  }
}
