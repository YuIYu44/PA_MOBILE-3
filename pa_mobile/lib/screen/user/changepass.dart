// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa_mobile/provider/error_notification.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'package:pa_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class ChangePass extends StatefulWidget {
  final email;
  const ChangePass(this.email);
  @override
  State<ChangePass> createState() => _ChangePass(email);
}

class _ChangePass extends State<ChangePass> {
  final email;
  _ChangePass(this.email);
  final TextEditingController oldController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ErrorNote>(
        create: (context) => ErrorNote(),
        child: WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Scaffold(
                appBar: appbar(context),
                body: SingleChildScrollView(
                    child: Padding(
                        padding: customEdgeInsets(context, 0.03, 0),
                        child: Center(
                          child: Consumer<ErrorNote>(
                              builder: (context, error_, child) {
                            return Column(children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 10,
                                      right: MediaQuery.sizeOf(context).width *
                                          0.7),
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: Icon(CupertinoIcons.back, size: 35),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )),
                              textfields(context, oldController, true,
                                  'Old Password', 14, 0.06, 0.65),
                              textfields(context, newController, true,
                                  'New Password', 14, 0.03, 0.65),
                              Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.65,
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.sizeOf(context).height *
                                          0.03),
                                  child: texts(context, error_.notif, 14,
                                      TextAlign.left)),
                              button(context, 'Change Password', 0.05, 0, 0.65,
                                  () async {
                                String errorNotif = await Auth().changepass(
                                    email,
                                    oldController.value.text,
                                    newController.value.text);
                                await error_.change(errorNotif);
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                if (errorNotif == "") {
                                  Navigator.pop(context);
                                }
                              }),
                            ]);
                          }),
                        ))))));
  }
}
