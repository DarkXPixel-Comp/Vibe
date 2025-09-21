// This is a generated file - do not edit.
//
// Generated from sync/sync.proto.

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

import 'sync.pb.dart' as $0;

export 'sync.pb.dart';

@$pb.GrpcServiceName('sync.SyncService')
class SyncServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SyncServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetStateResponse> getState(
    $0.GetStateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getState, request, options: options);
  }

  // method descriptors

  static final _$getState =
      $grpc.ClientMethod<$0.GetStateRequest, $0.GetStateResponse>(
          '/sync.SyncService/GetState',
          ($0.GetStateRequest value) => value.writeToBuffer(),
          $0.GetStateResponse.fromBuffer);
}

@$pb.GrpcServiceName('sync.SyncService')
abstract class SyncServiceBase extends $grpc.Service {
  $core.String get $name => 'sync.SyncService';

  SyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetStateRequest, $0.GetStateResponse>(
        'GetState',
        getState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetStateRequest.fromBuffer(value),
        ($0.GetStateResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetStateResponse> getState_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetStateRequest> $request) async {
    return getState($call, await $request);
  }

  $async.Future<$0.GetStateResponse> getState(
      $grpc.ServiceCall call, $0.GetStateRequest request);
}
