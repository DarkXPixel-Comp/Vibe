// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

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

import 'chat.pb.dart' as $0;

export 'chat.pb.dart';

@$pb.GrpcServiceName('chat.ChatService')
class ChatServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Message> sendMessage($0.SendMessageRequest request, {$grpc.CallOptions? options,}) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.ChatHistory> getChatMessages($0.GetChatMessagesRequest request, {$grpc.CallOptions? options,}) {
    return $createUnaryCall(_$getChatMessages, request, options: options);
  }

  $grpc.ResponseStream<$0.Message> streamMessages($0.StreamMessagesRequest request, {$grpc.CallOptions? options,}) {
    return $createStreamingCall(_$streamMessages, $async.Stream.fromIterable([request]), options: options);
  }

    // method descriptors

  static final _$sendMessage = $grpc.ClientMethod<$0.SendMessageRequest, $0.Message>(
      '/chat.ChatService/SendMessage',
      ($0.SendMessageRequest value) => value.writeToBuffer(),
      $0.Message.fromBuffer);
  static final _$getChatMessages = $grpc.ClientMethod<$0.GetChatMessagesRequest, $0.ChatHistory>(
      '/chat.ChatService/GetChatMessages',
      ($0.GetChatMessagesRequest value) => value.writeToBuffer(),
      $0.ChatHistory.fromBuffer);
  static final _$streamMessages = $grpc.ClientMethod<$0.StreamMessagesRequest, $0.Message>(
      '/chat.ChatService/StreamMessages',
      ($0.StreamMessagesRequest value) => value.writeToBuffer(),
      $0.Message.fromBuffer);
}

@$pb.GrpcServiceName('chat.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SendMessageRequest, $0.Message>(
        'SendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SendMessageRequest.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetChatMessagesRequest, $0.ChatHistory>(
        'GetChatMessages',
        getChatMessages_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetChatMessagesRequest.fromBuffer(value),
        ($0.ChatHistory value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamMessagesRequest, $0.Message>(
        'StreamMessages',
        streamMessages_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.StreamMessagesRequest.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
  }

  $async.Future<$0.Message> sendMessage_Pre($grpc.ServiceCall $call, $async.Future<$0.SendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.Message> sendMessage($grpc.ServiceCall call, $0.SendMessageRequest request);

  $async.Future<$0.ChatHistory> getChatMessages_Pre($grpc.ServiceCall $call, $async.Future<$0.GetChatMessagesRequest> $request) async {
    return getChatMessages($call, await $request);
  }

  $async.Future<$0.ChatHistory> getChatMessages($grpc.ServiceCall call, $0.GetChatMessagesRequest request);

  $async.Stream<$0.Message> streamMessages_Pre($grpc.ServiceCall $call, $async.Future<$0.StreamMessagesRequest> $request) async* {
    yield* streamMessages($call, await $request);
  }

  $async.Stream<$0.Message> streamMessages($grpc.ServiceCall call, $0.StreamMessagesRequest request);

}
