import 'package:flutter/material.dart';
import 'package:flutter_flask_login/src/screens/home/home_screen.dart';
import 'package:flutter_flask_login/src/screens/landing_screen.dart';
import 'package:flutter_flask_login/src/screens/login/login_screen.dart';
import 'package:flutter_flask_login/src/screens/register/register_screen.dart';

import '../SettingsRoute.dart';
import '../loginRoute.dart';
import '../profileRoute.dart';
import '../registerRoute.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flask Login',
      home: LandingScreen(),
      routes: {
        '/landing': (context) => LandingScreen(),
        //'/login': (context) => LoginRoute(),
        '/login': (context) => LoginScreen(),
        //'/register': (context) => RegisterRoute(),
        '/register' : (context) => RegisterScreen(),
        '/profile': (context) => ProfileRoute(),
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsRoute()
      },
    );
  }
}
