// This is a generated file - do not edit.
//
// Generated from user/user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pb.dart' as $0;

export 'user.pb.dart';

@$pb.GrpcServiceName('user.UserService')
class UserServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UserServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.UserResponse> getOrCreateUser(
    $0.GetOrCreateUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOrCreateUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserResponse> getUserByPhone(
    $0.GetUserByPhoneRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserByPhone, request, options: options);
  }

  // method descriptors

  static final _$getOrCreateUser =
      $grpc.ClientMethod<$0.GetOrCreateUserRequest, $0.UserResponse>(
          '/user.UserService/GetOrCreateUser',
          ($0.GetOrCreateUserRequest value) => value.writeToBuffer(),
          $0.UserResponse.fromBuffer);
  static final _$getUserByPhone =
      $grpc.ClientMethod<$0.GetUserByPhoneRequest, $0.UserResponse>(
          '/user.UserService/GetUserByPhone',
          ($0.GetUserByPhoneRequest value) => value.writeToBuffer(),
          $0.UserResponse.fromBuffer);
}

@$pb.GrpcServiceName('user.UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'user.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetOrCreateUserRequest, $0.UserResponse>(
        'GetOrCreateUser',
        getOrCreateUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetOrCreateUserRequest.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserByPhoneRequest, $0.UserResponse>(
        'GetUserByPhone',
        getUserByPhone_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUserByPhoneRequest.fromBuffer(value),
        ($0.UserResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.UserResponse> getOrCreateUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetOrCreateUserRequest> $request) async {
    return getOrCreateUser($call, await $request);
  }

  $async.Future<$0.UserResponse> getOrCreateUser(
      $grpc.ServiceCall call, $0.GetOrCreateUserRequest request);

  $async.Future<$0.UserResponse> getUserByPhone_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetUserByPhoneRequest> $request) async {
    return getUserByPhone($call, await $request);
  }

  $async.Future<$0.UserResponse> getUserByPhone(
      $grpc.ServiceCall call, $0.GetUserByPhoneRequest request);
}
