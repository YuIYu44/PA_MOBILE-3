import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa_mobile/firebase_options.dart';
import 'package:pa_mobile/screen/admin/home_admin.dart';
import 'package:pa_mobile/screen/intro.dart';
import 'package:pa_mobile/screen/user/home.dart';
import 'package:pa_mobile/provider/change_theme.dart';
import 'package:pa_mobile/services/user_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider<CustomTheme>(
    create: (_) => CustomTheme(0),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Provider.of<CustomTheme>(context).currentTheme,
        home: FutureBuilder(
            future: userservice().uservalue(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data["status"] == "admin") {
                    return home_admin();
                  } else if (snapshot.data["status"] == "user") {
                    return home();
                  }
                } else {
                  return IntroductionPage();
                }
              }
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }));
  }
}
