
import 'package:flutter_flask_login/src/repositories/shared_preferences_repository.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

class AuthRepository {

  AuthRepository();

  var sharedPreferencesRepo = serviceLocator.get<Preferences>();

  Future<bool> isUserLoggedIn() async{
    var token = await getSavedToken();
    if(token == null || token.isEmpty)
      return false;
    return true;
  }

  Future<String> getSavedToken()async{
    var token = await sharedPreferencesRepo.getUserToken();
    return token;
  }

  Future<void> saveToken(String newToken) async{
    await sharedPreferencesRepo.setUserToken(newToken);
  }

  Future<void> clearToken() async{
    await sharedPreferencesRepo.setUserToken("");
  }

  Future<void> logout() async{
    await clearToken();
  }

}