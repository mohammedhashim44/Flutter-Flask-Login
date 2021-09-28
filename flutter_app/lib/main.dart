import 'package:flutter/material.dart';
import 'package:flutter_flask_login/src/app.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();

  runApp(MyApp());
}
