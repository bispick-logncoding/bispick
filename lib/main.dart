import 'package:bispick/firebase_options.dart';
import 'package:bispick/pages/MyPage.dart';
import 'package:bispick/pages/RouteGuard.dart';
import 'package:bispick/pages/alllostthings.dart';
import 'package:bispick/pages/camerapage.dart';
import 'package:bispick/pages/clothing.dart';
import 'package:bispick/pages/edevice.dart';
import 'package:bispick/pages/LoginPage.dart';
import 'package:bispick/pages/others.dart';
import 'package:bispick/pages/registerpage.dart';
import 'package:bispick/pages/requestpage.dart';
import 'package:bispick/pages/stationary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DefaultFirebaseOptions defaultFirebaseOptions = new DefaultFirebaseOptions();
  await Firebase.initializeApp(options: defaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'BIS | Lost and Found', initialRoute: 'loginView', routes: {
      'loginView': (context) => LoginPage(),
      'registerView': (context) => RegisterPage(),
      'homeView': (context) => RouteGuard(child: MainPage()),
      'myPageView': (context) => RouteGuard(child: MyPage()),
      'cameraView': (context) => RouteGuard(child: CameraPage()),
      'allLostItemsView': (context) => RouteGuard(child: AllLostThings()),
      'requestView': (context) => RouteGuard(child: RequestPage()),
      'othersView': (context) => RouteGuard(child: Others()),
      'stationaryView': (context) => RouteGuard(child: Stationery()),
      'edeviceView': (context) => RouteGuard(child: Edevice()),
      'clothingView': (context) => RouteGuard(child: Clothing()),
    });
  }
}
