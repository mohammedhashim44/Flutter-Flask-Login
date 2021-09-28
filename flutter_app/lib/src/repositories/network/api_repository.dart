import 'package:dio/dio.dart';
import 'package:flutter_flask_login/src/repositories/network/responses/login_response.dart';
import 'package:flutter_flask_login/src/repositories/network/responses/profile_response.dart';

import '../../utils/service_locator.dart';
import '../shared_preferences_repository.dart';
import 'responses/base_response.dart';
import 'server_error.dart';

String testConnectionEndPoint(String baseUrl) => baseUrl + "test";

String loginEndPoint(String baseUrl) => baseUrl + "login";

String registerEndPoint(String baseUrl) => baseUrl + "register";

String getProfileEndPoint(String baseUrl) => baseUrl + "get_profile";

int timeoutInSeconds = 10;

class ApiRepository {

  Dio _dio;
  String baseUrl;
  var sharedPreferencesRepo = serviceLocator.get<Preferences>();

  ApiRepository(this.baseUrl) {
    initDio();
  }

  void initDio() {
    BaseOptions options = new BaseOptions(
        connectTimeout: timeoutInSeconds *1000,
        receiveTimeout: timeoutInSeconds *1000,
        headers: {'content-Type':'application/json'},
    );

    _dio = Dio(options);
  }

  void updateBaseUrl(String url) async {
    this.baseUrl = url;
  }

  Future<bool> testConnection() async {
    try {
      Response response = await _dio.get(testConnectionEndPoint(baseUrl));
      if (response.statusCode == 200) return true;
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<BaseResponse<LoginResponse>> login(
      String username, String password) async {
    BaseResponse<LoginResponse> response =
        await performRequest(url: loginEndPoint(baseUrl), data: {
      "username": username,
      "password": password,
    });
    return response;
  }

  Future<BaseResponse> register(
      String username, String fullname, String email, String password) async {
    BaseResponse response = await performRequest(
      url: registerEndPoint(baseUrl),
      data: {
        "username": username,
        "fullname": fullname,
        "password": password,
        "email": email,
      },
    );
    return response;
  }

  Future<BaseResponse<ProfileResponse>> loadProfile(String token) async {
    BaseResponse<ProfileResponse> response = await performRequest(
      url: getProfileEndPoint(baseUrl),
      data: {"token": token},
    );
    return response;
  }

  // Helper function
  Future<BaseResponse<T>> performRequest<T>(
      {String url, Map<String, dynamic> data = const {}}) async {
    try {
      var response = await _dio.post(
        url,
        data: data,
      );
      return BaseResponse.fromJson(response.data);
    } catch (error) {
      return BaseResponse(status: false)
        ..setException(ServerError.withError(error: error));
    }
  }
}
