// This is a generated file - do not edit.
//
// Generated from auth/auth.proto.

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

import 'auth.pb.dart' as $0;

export 'auth.pb.dart';

@$pb.GrpcServiceName('auth.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.SendCodeResponse> sendVerificationCode(
    $0.PhoneNumberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendVerificationCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.AuthResponse> verifyCode(
    $0.VerifyCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.ValidateTokenRespone> validateToken(
    $0.ValidateTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$validateToken, request, options: options);
  }

  // method descriptors

  static final _$sendVerificationCode =
      $grpc.ClientMethod<$0.PhoneNumberRequest, $0.SendCodeResponse>(
          '/auth.AuthService/SendVerificationCode',
          ($0.PhoneNumberRequest value) => value.writeToBuffer(),
          $0.SendCodeResponse.fromBuffer);
  static final _$verifyCode =
      $grpc.ClientMethod<$0.VerifyCodeRequest, $0.AuthResponse>(
          '/auth.AuthService/VerifyCode',
          ($0.VerifyCodeRequest value) => value.writeToBuffer(),
          $0.AuthResponse.fromBuffer);
  static final _$validateToken =
      $grpc.ClientMethod<$0.ValidateTokenRequest, $0.ValidateTokenRespone>(
          '/auth.AuthService/ValidateToken',
          ($0.ValidateTokenRequest value) => value.writeToBuffer(),
          $0.ValidateTokenRespone.fromBuffer);
}

@$pb.GrpcServiceName('auth.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'auth.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PhoneNumberRequest, $0.SendCodeResponse>(
        'SendVerificationCode',
        sendVerificationCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.PhoneNumberRequest.fromBuffer(value),
        ($0.SendCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VerifyCodeRequest, $0.AuthResponse>(
        'VerifyCode',
        verifyCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.VerifyCodeRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ValidateTokenRequest, $0.ValidateTokenRespone>(
            'ValidateToken',
            validateToken_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ValidateTokenRequest.fromBuffer(value),
            ($0.ValidateTokenRespone value) => value.writeToBuffer()));
  }

  $async.Future<$0.SendCodeResponse> sendVerificationCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PhoneNumberRequest> $request) async {
    return sendVerificationCode($call, await $request);
  }

  $async.Future<$0.SendCodeResponse> sendVerificationCode(
      $grpc.ServiceCall call, $0.PhoneNumberRequest request);

  $async.Future<$0.AuthResponse> verifyCode_Pre($grpc.ServiceCall $call,
      $async.Future<$0.VerifyCodeRequest> $request) async {
    return verifyCode($call, await $request);
  }

  $async.Future<$0.AuthResponse> verifyCode(
      $grpc.ServiceCall call, $0.VerifyCodeRequest request);

  $async.Future<$0.ValidateTokenRespone> validateToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ValidateTokenRequest> $request) async {
    return validateToken($call, await $request);
  }

  $async.Future<$0.ValidateTokenRespone> validateToken(
      $grpc.ServiceCall call, $0.ValidateTokenRequest request);
}
