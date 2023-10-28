import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa_mobile/screen/widget.dart';
import 'welcome.dart';
import 'package:provider/provider.dart';

//disini bakal ada pengecekan preference apakah pernah login atau tidak =>database
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
      home: welcome(),
    );
  }
}
