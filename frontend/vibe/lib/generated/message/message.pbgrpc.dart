// This is a generated file - do not edit.
//
// Generated from message/message.proto.

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

import 'message.pb.dart' as $0;

export 'message.pb.dart';

@$pb.GrpcServiceName('message.MessageService')
class MessageServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MessageServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListMessageResponse> listMessages(
    $0.ListMessagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMessages, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteMessageResponse> deleteMessage(
    $0.DeleteMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteMessage, request, options: options);
  }

  // method descriptors

  static final _$listMessages =
      $grpc.ClientMethod<$0.ListMessagesRequest, $0.ListMessageResponse>(
          '/message.MessageService/ListMessages',
          ($0.ListMessagesRequest value) => value.writeToBuffer(),
          $0.ListMessageResponse.fromBuffer);
  static final _$deleteMessage =
      $grpc.ClientMethod<$0.DeleteMessageRequest, $0.DeleteMessageResponse>(
          '/message.MessageService/DeleteMessage',
          ($0.DeleteMessageRequest value) => value.writeToBuffer(),
          $0.DeleteMessageResponse.fromBuffer);
}

@$pb.GrpcServiceName('message.MessageService')
abstract class MessageServiceBase extends $grpc.Service {
  $core.String get $name => 'message.MessageService';

  MessageServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListMessagesRequest, $0.ListMessageResponse>(
            'ListMessages',
            listMessages_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListMessagesRequest.fromBuffer(value),
            ($0.ListMessageResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteMessageRequest, $0.DeleteMessageResponse>(
            'DeleteMessage',
            deleteMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteMessageRequest.fromBuffer(value),
            ($0.DeleteMessageResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListMessageResponse> listMessages_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListMessagesRequest> $request) async {
    return listMessages($call, await $request);
  }

  $async.Future<$0.ListMessageResponse> listMessages(
      $grpc.ServiceCall call, $0.ListMessagesRequest request);

  $async.Future<$0.DeleteMessageResponse> deleteMessage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteMessageRequest> $request) async {
    return deleteMessage($call, await $request);
  }

  $async.Future<$0.DeleteMessageResponse> deleteMessage(
      $grpc.ServiceCall call, $0.DeleteMessageRequest request);
}
