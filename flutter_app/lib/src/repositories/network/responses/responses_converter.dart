import 'package:flutter_flask_login/src/repositories/network/responses/login_response.dart';
import 'package:flutter_flask_login/src/repositories/network/responses/profile_response.dart';

class ResponsesConverter {
  static T generateObjectFromJson<T>(Map<String, dynamic> json) {
    if (json == null) return null;
    if (T == LoginResponse) return LoginResponse.fromJson(json) as T;
    if (T == ProfileResponse) return ProfileResponse.fromJson(json) as T;
    throw UnimplementedError();
  }
}
