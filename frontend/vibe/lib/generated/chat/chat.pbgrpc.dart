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

  $grpc.ResponseFuture<$0.CreateChatResponse> createChat(
    $0.CreateChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createChat, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddUserToChatResponse> addUserToChat(
    $0.AddUserToChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addUserToChat, request, options: options);
  }

  $grpc.ResponseFuture<$0.ChatResponse> getChat(
    $0.GetChatRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getChat, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListUserChatResponse> listUserChats(
    $0.ListUserChatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listUserChats, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetChatsResponse> getChats(
    $0.GetChatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getChats, request, options: options);
  }

  // method descriptors

  static final _$createChat =
      $grpc.ClientMethod<$0.CreateChatRequest, $0.CreateChatResponse>(
          '/chat.ChatService/CreateChat',
          ($0.CreateChatRequest value) => value.writeToBuffer(),
          $0.CreateChatResponse.fromBuffer);
  static final _$addUserToChat =
      $grpc.ClientMethod<$0.AddUserToChatRequest, $0.AddUserToChatResponse>(
          '/chat.ChatService/AddUserToChat',
          ($0.AddUserToChatRequest value) => value.writeToBuffer(),
          $0.AddUserToChatResponse.fromBuffer);
  static final _$getChat =
      $grpc.ClientMethod<$0.GetChatRequest, $0.ChatResponse>(
          '/chat.ChatService/GetChat',
          ($0.GetChatRequest value) => value.writeToBuffer(),
          $0.ChatResponse.fromBuffer);
  static final _$listUserChats =
      $grpc.ClientMethod<$0.ListUserChatsRequest, $0.ListUserChatResponse>(
          '/chat.ChatService/ListUserChats',
          ($0.ListUserChatsRequest value) => value.writeToBuffer(),
          $0.ListUserChatResponse.fromBuffer);
  static final _$getChats =
      $grpc.ClientMethod<$0.GetChatsRequest, $0.GetChatsResponse>(
          '/chat.ChatService/GetChats',
          ($0.GetChatsRequest value) => value.writeToBuffer(),
          $0.GetChatsResponse.fromBuffer);
}

@$pb.GrpcServiceName('chat.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateChatRequest, $0.CreateChatResponse>(
        'CreateChat',
        createChat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateChatRequest.fromBuffer(value),
        ($0.CreateChatResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddUserToChatRequest, $0.AddUserToChatResponse>(
            'AddUserToChat',
            addUserToChat_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddUserToChatRequest.fromBuffer(value),
            ($0.AddUserToChatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetChatRequest, $0.ChatResponse>(
        'GetChat',
        getChat_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetChatRequest.fromBuffer(value),
        ($0.ChatResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListUserChatsRequest, $0.ListUserChatResponse>(
            'ListUserChats',
            listUserChats_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListUserChatsRequest.fromBuffer(value),
            ($0.ListUserChatResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetChatsRequest, $0.GetChatsResponse>(
        'GetChats',
        getChats_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetChatsRequest.fromBuffer(value),
        ($0.GetChatsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreateChatResponse> createChat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateChatRequest> $request) async {
    return createChat($call, await $request);
  }

  $async.Future<$0.CreateChatResponse> createChat(
      $grpc.ServiceCall call, $0.CreateChatRequest request);

  $async.Future<$0.AddUserToChatResponse> addUserToChat_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AddUserToChatRequest> $request) async {
    return addUserToChat($call, await $request);
  }

  $async.Future<$0.AddUserToChatResponse> addUserToChat(
      $grpc.ServiceCall call, $0.AddUserToChatRequest request);

  $async.Future<$0.ChatResponse> getChat_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetChatRequest> $request) async {
    return getChat($call, await $request);
  }

  $async.Future<$0.ChatResponse> getChat(
      $grpc.ServiceCall call, $0.GetChatRequest request);

  $async.Future<$0.ListUserChatResponse> listUserChats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListUserChatsRequest> $request) async {
    return listUserChats($call, await $request);
  }

  $async.Future<$0.ListUserChatResponse> listUserChats(
      $grpc.ServiceCall call, $0.ListUserChatsRequest request);

  $async.Future<$0.GetChatsResponse> getChats_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetChatsRequest> $request) async {
    return getChats($call, await $request);
  }

  $async.Future<$0.GetChatsResponse> getChats(
      $grpc.ServiceCall call, $0.GetChatsRequest request);
}
