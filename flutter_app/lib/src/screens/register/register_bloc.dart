import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_flask_login/src/repositories/auth_repository.dart';
import 'package:flutter_flask_login/src/repositories/network/api_repository.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

/// EVENTS
abstract class RegisterEvent {}

class AttemptRegister extends RegisterEvent {
  final String username;
  final String fullname;
  final String email;
  final String password;

  AttemptRegister(this.username, this.fullname, this.email, this.password);
}

/// STATES
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
}

/// BLOC CLASS
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository = serviceLocator.get<AuthRepository>();
  final ApiRepository apiRepository = serviceLocator.get<ApiRepository>();

  RegisterBloc() : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is AttemptRegister) {
      yield* onAttemptRegister(event);
    }
  }

  Stream<RegisterState> onAttemptRegister(AttemptRegister event) async* {
    yield RegisterLoading();
    var response = await apiRepository.register(
      event.username,
      event.fullname,
      event.email,
      event.password,
    );
    if (response.status == true) {
      yield RegisterSuccess();
    } else {
      String error;
      if (response.hasServerError)
        error = response.getException.getErrorMessage();
      else
        error = response.msg.toString();
      yield RegisterError(error);
    }
  }
}
