import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_flask_login/src/repositories/auth_repository.dart';
import 'package:flutter_flask_login/src/repositories/network/api_repository.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

/// EVENTS
abstract class LoginEvent {}

class AttemptLogin extends LoginEvent {
  final String username;
  final String password;

  AttemptLogin(this.username, this.password);
}

/// STATES
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

/// BLOC CLASS
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository = serviceLocator.get<AuthRepository>();
  final ApiRepository apiRepository = serviceLocator.get<ApiRepository>();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is AttemptLogin) {
      yield* onAttemptLogin(event);
    }
  }

  Stream<LoginState> onAttemptLogin(AttemptLogin event) async* {
    yield LoginLoading();
    var response = await apiRepository.login(
      event.username,
      event.password,
    );
    if (response.status == true) {
      // Save token in shared preferences
      String token = response.data.token;
      await authRepository.saveToken(token);
      yield LoginSuccess();
    } else {
      String error;
      if (response.hasServerError)
        error = response.getException.getErrorMessage();
      else
        error = response.msg.toString();
      yield LoginError(error);
    }
  }
}
