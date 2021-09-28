import 'package:flutter_flask_login/src/repositories/network/responses/responses_converter.dart';

import '../server_error.dart';

class BaseResponse<T> {
  bool status;

  String msg;

  T data;

  BaseResponse({this.status, this.msg, this.data});

  ServerError _error;

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json["status"],
      msg: json["message"],
      data: ResponsesConverter.generateObjectFromJson<T>(json["data"]),
    );
  }

  setException(ServerError error) {
    _error = error;
  }

  ServerError get getException {
    return _error;
  }

  bool get hasServerError {
    return _error != null;
  }
}
