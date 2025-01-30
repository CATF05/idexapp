// import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/secretaire/secretaire.dart';
import 'package:frontend/screens/comptable/account_screen.dart';
import 'package:frontend/screens/surveillant/surveillant_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/DE/de_screen.dart';
import 'package:frontend/screens/DG/dg_screen.dart';

import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Verifier la plateform
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    // Fixer les parametres de la fenetre
    WindowOptions windowOptions = const WindowOptions(
      // size: Size(1360, 790),
      center: true,
      minimumSize: Size(1360, 700),
      // backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: "IDEX-APP",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),

      home: DGScreen(),
      // home: AccountantScreen(),
      // home: SecretaryScreen(),
      // home: DirecteurEtudesScreen(),
      // home: SurveillantGeneralScreen(),
      // home: const LoginScreen(),
    );
  }
}