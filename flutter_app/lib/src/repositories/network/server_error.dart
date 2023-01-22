import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';

class ServerError implements Exception {
  int _errorCode;
  String _errorMessage = "";

  ServerError.withError({@required DioError error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        _errorMessage = "Connection Canceled";
        break;
      case DioErrorType.connectTimeout:
        _errorMessage = "Connection Timeout";
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Connection Timeout";
        break;
      case DioErrorType.response:
        _errorMessage = "Invalid Status Code";
        break;
      case DioErrorType.sendTimeout:
        _errorMessage = "Connection Timeout";
        break;
      default:
        _errorMessage = "Unkown Connection Error";
    }
    return _errorMessage;
  }
}
