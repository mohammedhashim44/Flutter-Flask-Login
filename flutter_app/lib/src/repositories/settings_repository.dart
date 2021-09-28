import 'package:flutter_flask_login/src/repositories/shared_preferences_repository.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

String defaultURL = "http://192.168.1.1:5000/API/";

class SettingsRepository {
  SettingsRepository();

  var sharedPreferencesRepo = serviceLocator.get<Preferences>();

  Future<String> getSavedURL() async {
    var url = await sharedPreferencesRepo.getURL();
    if (url == null || url.isEmpty) url = defaultURL;
    return url;
  }

  Future<void> saveURL(String newUrl) async {
    await sharedPreferencesRepo.setURL(newUrl);
  }
}
