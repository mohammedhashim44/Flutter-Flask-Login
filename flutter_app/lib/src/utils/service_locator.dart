import 'package:flutter_flask_login/src/repositories/auth_repository.dart';
import 'package:flutter_flask_login/src/repositories/network/api_repository.dart';
import 'package:flutter_flask_login/src/repositories/settings_repository.dart';
import 'package:flutter_flask_login/src/repositories/shared_preferences_repository.dart';
import 'package:get_it/get_it.dart';

import '../repositories/shared_preferences_repository.dart';

Future<void> setupServiceLocator() async {
  serviceLocator.registerSingleton<Preferences>(preferences);
  serviceLocator.registerSingleton<AuthRepository>(AuthRepository());
  serviceLocator.registerSingleton<SettingsRepository>(SettingsRepository());

  String url = await serviceLocator.get<Preferences>().getURL();
  serviceLocator.registerSingleton<ApiRepository>(ApiRepository(url));
}

final serviceLocator = GetIt.instance;
