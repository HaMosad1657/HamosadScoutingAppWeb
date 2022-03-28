import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hamosad_scouting_app/misc/database.dart';
import 'package:hamosad_scouting_app/pages/pages.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

void main() async {
  if (!kIsWeb && Platform.isWindows) {
    runApp(const WindowsApp());
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    initData();
    getTeams();
    runApp(
      const RestartWidget(
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    pages = {
      "home": HomePage(),
    };

    return MaterialApp(
      title: "Scouting 1657",
      home: pages["home"],
      theme: ThemeData.dark(),
    );
  }
}

class WindowsApp extends StatelessWidget {
  const WindowsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scouting 1657",
      home: Scaffold(
        body: Center(
          child: Text(
            "This app is not supported by Windows.\nYou can try it in Android, iOS and web.",
            style: AppFont(size: 45, fontWeight: FontWeight.bold).getFont(),
          ),
        ),
      ),
      theme: ThemeData.dark(),
    );
  }
}
