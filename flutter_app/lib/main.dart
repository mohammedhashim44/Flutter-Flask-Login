import 'package:flutter/material.dart';
import 'loginRoute.dart';
import 'registerRoute.dart';
import 'profileRoute.dart';
import 'SettingsRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = (prefs.getBool('isLogged') ?? false) ;

  var home;
  if(isLogged)
    home = ProfileRoute();
  else
    home = LoginRoute() ;

  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: home,
    routes: {
      '/login' : (context) => LoginRoute() ,
      '/register' : (context) => RegisterRoute() ,
      '/profile' : (context) => ProfileRoute() ,
      '/settings' : (context) => SettingsRoute()
    },

  ));
}
