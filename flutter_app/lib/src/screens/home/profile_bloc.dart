import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_flask_login/src/repositories/auth_repository.dart';
import 'package:flutter_flask_login/src/repositories/network/api_repository.dart';
import 'package:flutter_flask_login/src/repositories/network/responses/profile_response.dart';
import 'package:flutter_flask_login/src/utils/service_locator.dart';

/// EVENTS
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

/// STATES
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileResponse profileResponse;

  ProfileSuccess(this.profileResponse);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}

/// BLOC CLASS
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository = serviceLocator.get<AuthRepository>();
  final ApiRepository apiRepository = serviceLocator.get<ApiRepository>();

  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield* onLoadProfile(event);
    }
  }

  Stream<ProfileState> onLoadProfile(LoadProfile event) async* {
    yield ProfileLoading();

    // Get token from shared preferences
    String token = await authRepository.getSavedToken();
    var response = await apiRepository.loadProfile(token);
    if (response.status == true) {
      ProfileResponse profileResponse = response.data;
      yield ProfileSuccess(profileResponse);
    } else {
      String error;
      if (response.hasServerError)
        error = response.getException.getErrorMessage();
      else
        error = response.msg.toString();
      yield ProfileError(error);
    }
  }
}
