// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) {
  return ProfileResponse(
    username: json['username'] as String,
    fullname: json['fullname'] as String,
    email: json['email'] as String,
    loginCounts: json['login_counts'] as int,
  );
}

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'fullname': instance.fullname,
      'email': instance.email,
      'login_counts': instance.loginCounts,
    };
