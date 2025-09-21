// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'chat.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'chat.pbenum.dart';

class DeleteChatRequest extends $pb.GeneratedMessage {
  factory DeleteChatRequest({
    $core.String? chatId,
  }) {
    final result = create();
    if (chatId != null) result.chatId = chatId;
    return result;
  }

  DeleteChatRequest._();

  factory DeleteChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteChatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chatId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChatRequest clone() => DeleteChatRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChatRequest copyWith(void Function(DeleteChatRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteChatRequest))
          as DeleteChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteChatRequest create() => DeleteChatRequest._();
  @$core.override
  DeleteChatRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteChatRequest> createRepeated() =>
      $pb.PbList<DeleteChatRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteChatRequest>(create);
  static DeleteChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chatId => $_getSZ(0);
  @$pb.TagNumber(1)
  set chatId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatId() => $_clearField(1);
}

class DeleteChatResponse extends $pb.GeneratedMessage {
  factory DeleteChatResponse({
    $core.bool? success,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  DeleteChatResponse._();

  factory DeleteChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteChatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChatResponse clone() => DeleteChatResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteChatResponse copyWith(void Function(DeleteChatResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteChatResponse))
          as DeleteChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteChatResponse create() => DeleteChatResponse._();
  @$core.override
  DeleteChatResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteChatResponse> createRepeated() =>
      $pb.PbList<DeleteChatResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteChatResponse>(create);
  static DeleteChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);
}

class CreateChatRequest extends $pb.GeneratedMessage {
  factory CreateChatRequest({
    ChatType? type,
    $core.String? title,
    $core.String? creatorId,
    $core.Iterable<$core.String>? userIds,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (title != null) result.title = title;
    if (creatorId != null) result.creatorId = creatorId;
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  CreateChatRequest._();

  factory CreateChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..e<ChatType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE,
        defaultOrMaker: ChatType.PRIVATE,
        valueOf: ChatType.valueOf,
        enumValues: ChatType.values)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'creatorId')
    ..pPS(4, _omitFieldNames ? '' : 'userIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChatRequest clone() => CreateChatRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChatRequest copyWith(void Function(CreateChatRequest) updates) =>
      super.copyWith((message) => updates(message as CreateChatRequest))
          as CreateChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateChatRequest create() => CreateChatRequest._();
  @$core.override
  CreateChatRequest createEmptyInstance() => create();
  static $pb.PbList<CreateChatRequest> createRepeated() =>
      $pb.PbList<CreateChatRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChatRequest>(create);
  static CreateChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChatType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ChatType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get userIds => $_getList(3);
}

class CreateChatResponse extends $pb.GeneratedMessage {
  factory CreateChatResponse({
    $core.bool? success,
    Chat? chat,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (chat != null) result.chat = chat;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  CreateChatResponse._();

  factory CreateChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateChatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<Chat>(2, _omitFieldNames ? '' : 'chat', subBuilder: Chat.create)
    ..aOS(3, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChatResponse clone() => CreateChatResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateChatResponse copyWith(void Function(CreateChatResponse) updates) =>
      super.copyWith((message) => updates(message as CreateChatResponse))
          as CreateChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateChatResponse create() => CreateChatResponse._();
  @$core.override
  CreateChatResponse createEmptyInstance() => create();
  static $pb.PbList<CreateChatResponse> createRepeated() =>
      $pb.PbList<CreateChatResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateChatResponse>(create);
  static CreateChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  Chat get chat => $_getN(1);
  @$pb.TagNumber(2)
  set chat(Chat value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChat() => $_has(1);
  @$pb.TagNumber(2)
  void clearChat() => $_clearField(2);
  @$pb.TagNumber(2)
  Chat ensureChat() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => $_clearField(3);
}

class AddUserToChatRequest extends $pb.GeneratedMessage {
  factory AddUserToChatRequest({
    $core.String? chatId,
    $core.String? userId,
  }) {
    final result = create();
    if (chatId != null) result.chatId = chatId;
    if (userId != null) result.userId = userId;
    return result;
  }

  AddUserToChatRequest._();

  factory AddUserToChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddUserToChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddUserToChatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chatId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserToChatRequest clone() =>
      AddUserToChatRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserToChatRequest copyWith(void Function(AddUserToChatRequest) updates) =>
      super.copyWith((message) => updates(message as AddUserToChatRequest))
          as AddUserToChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddUserToChatRequest create() => AddUserToChatRequest._();
  @$core.override
  AddUserToChatRequest createEmptyInstance() => create();
  static $pb.PbList<AddUserToChatRequest> createRepeated() =>
      $pb.PbList<AddUserToChatRequest>();
  @$core.pragma('dart2js:noInline')
  static AddUserToChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddUserToChatRequest>(create);
  static AddUserToChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chatId => $_getSZ(0);
  @$pb.TagNumber(1)
  set chatId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class AddUserToChatResponse extends $pb.GeneratedMessage {
  factory AddUserToChatResponse({
    $core.bool? success,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  AddUserToChatResponse._();

  factory AddUserToChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddUserToChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddUserToChatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserToChatResponse clone() =>
      AddUserToChatResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserToChatResponse copyWith(
          void Function(AddUserToChatResponse) updates) =>
      super.copyWith((message) => updates(message as AddUserToChatResponse))
          as AddUserToChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddUserToChatResponse create() => AddUserToChatResponse._();
  @$core.override
  AddUserToChatResponse createEmptyInstance() => create();
  static $pb.PbList<AddUserToChatResponse> createRepeated() =>
      $pb.PbList<AddUserToChatResponse>();
  @$core.pragma('dart2js:noInline')
  static AddUserToChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddUserToChatResponse>(create);
  static AddUserToChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);
}

class GetChatRequest extends $pb.GeneratedMessage {
  factory GetChatRequest({
    $core.String? chatId,
  }) {
    final result = create();
    if (chatId != null) result.chatId = chatId;
    return result;
  }

  GetChatRequest._();

  factory GetChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChatRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chatId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatRequest clone() => GetChatRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatRequest copyWith(void Function(GetChatRequest) updates) =>
      super.copyWith((message) => updates(message as GetChatRequest))
          as GetChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChatRequest create() => GetChatRequest._();
  @$core.override
  GetChatRequest createEmptyInstance() => create();
  static $pb.PbList<GetChatRequest> createRepeated() =>
      $pb.PbList<GetChatRequest>();
  @$core.pragma('dart2js:noInline')
  static GetChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChatRequest>(create);
  static GetChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chatId => $_getSZ(0);
  @$pb.TagNumber(1)
  set chatId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatId() => $_clearField(1);
}

class GetChatsRequest extends $pb.GeneratedMessage {
  factory GetChatsRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetChatsRequest._();

  factory GetChatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatsRequest clone() => GetChatsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatsRequest copyWith(void Function(GetChatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetChatsRequest))
          as GetChatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChatsRequest create() => GetChatsRequest._();
  @$core.override
  GetChatsRequest createEmptyInstance() => create();
  static $pb.PbList<GetChatsRequest> createRepeated() =>
      $pb.PbList<GetChatsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetChatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChatsRequest>(create);
  static GetChatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class GetChatsResponse extends $pb.GeneratedMessage {
  factory GetChatsResponse({
    $core.Iterable<Chat>? chats,
  }) {
    final result = create();
    if (chats != null) result.chats.addAll(chats);
    return result;
  }

  GetChatsResponse._();

  factory GetChatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChatsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..pc<Chat>(1, _omitFieldNames ? '' : 'chats', $pb.PbFieldType.PM,
        subBuilder: Chat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatsResponse clone() => GetChatsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatsResponse copyWith(void Function(GetChatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetChatsResponse))
          as GetChatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChatsResponse create() => GetChatsResponse._();
  @$core.override
  GetChatsResponse createEmptyInstance() => create();
  static $pb.PbList<GetChatsResponse> createRepeated() =>
      $pb.PbList<GetChatsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetChatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChatsResponse>(create);
  static GetChatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Chat> get chats => $_getList(0);
}

class ChatResponse extends $pb.GeneratedMessage {
  factory ChatResponse({
    $core.bool? success,
    $core.String? errorMessage,
    Chat? chat,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (chat != null) result.chat = chat;
    return result;
  }

  ChatResponse._();

  factory ChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<Chat>(3, _omitFieldNames ? '' : 'chat', subBuilder: Chat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatResponse clone() => ChatResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatResponse copyWith(void Function(ChatResponse) updates) =>
      super.copyWith((message) => updates(message as ChatResponse))
          as ChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatResponse create() => ChatResponse._();
  @$core.override
  ChatResponse createEmptyInstance() => create();
  static $pb.PbList<ChatResponse> createRepeated() =>
      $pb.PbList<ChatResponse>();
  @$core.pragma('dart2js:noInline')
  static ChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatResponse>(create);
  static ChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  Chat get chat => $_getN(2);
  @$pb.TagNumber(3)
  set chat(Chat value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChat() => $_has(2);
  @$pb.TagNumber(3)
  void clearChat() => $_clearField(3);
  @$pb.TagNumber(3)
  Chat ensureChat() => $_ensure(2);
}

class ListUserChatsRequest extends $pb.GeneratedMessage {
  factory ListUserChatsRequest({
    $core.String? userId,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListUserChatsRequest._();

  factory ListUserChatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserChatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserChatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserChatsRequest clone() =>
      ListUserChatsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserChatsRequest copyWith(void Function(ListUserChatsRequest) updates) =>
      super.copyWith((message) => updates(message as ListUserChatsRequest))
          as ListUserChatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserChatsRequest create() => ListUserChatsRequest._();
  @$core.override
  ListUserChatsRequest createEmptyInstance() => create();
  static $pb.PbList<ListUserChatsRequest> createRepeated() =>
      $pb.PbList<ListUserChatsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListUserChatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserChatsRequest>(create);
  static ListUserChatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class ListUserChatResponse extends $pb.GeneratedMessage {
  factory ListUserChatResponse({
    $core.Iterable<Chat>? chats,
  }) {
    final result = create();
    if (chats != null) result.chats.addAll(chats);
    return result;
  }

  ListUserChatResponse._();

  factory ListUserChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserChatResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..pc<Chat>(1, _omitFieldNames ? '' : 'chats', $pb.PbFieldType.PM,
        subBuilder: Chat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserChatResponse clone() =>
      ListUserChatResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserChatResponse copyWith(void Function(ListUserChatResponse) updates) =>
      super.copyWith((message) => updates(message as ListUserChatResponse))
          as ListUserChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserChatResponse create() => ListUserChatResponse._();
  @$core.override
  ListUserChatResponse createEmptyInstance() => create();
  static $pb.PbList<ListUserChatResponse> createRepeated() =>
      $pb.PbList<ListUserChatResponse>();
  @$core.pragma('dart2js:noInline')
  static ListUserChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserChatResponse>(create);
  static ListUserChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Chat> get chats => $_getList(0);
}

class Chat extends $pb.GeneratedMessage {
  factory Chat({
    $core.String? id,
    ChatType? type,
    $core.String? title,
    $core.String? creatorId,
    $core.String? createdAt,
    $core.String? updatedAt,
    $core.Iterable<$core.String>? userIds,
    $core.int? memberCount,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (title != null) result.title = title;
    if (creatorId != null) result.creatorId = creatorId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (userIds != null) result.userIds.addAll(userIds);
    if (memberCount != null) result.memberCount = memberCount;
    return result;
  }

  Chat._();

  factory Chat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..e<ChatType>(2, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE,
        defaultOrMaker: ChatType.PRIVATE,
        valueOf: ChatType.valueOf,
        enumValues: ChatType.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'creatorId')
    ..aOS(5, _omitFieldNames ? '' : 'createdAt')
    ..aOS(6, _omitFieldNames ? '' : 'updatedAt')
    ..pPS(7, _omitFieldNames ? '' : 'userIds')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'memberCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chat clone() => Chat()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chat copyWith(void Function(Chat) updates) =>
      super.copyWith((message) => updates(message as Chat)) as Chat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chat create() => Chat._();
  @$core.override
  Chat createEmptyInstance() => create();
  static $pb.PbList<Chat> createRepeated() => $pb.PbList<Chat>();
  @$core.pragma('dart2js:noInline')
  static Chat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chat>(create);
  static Chat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ChatType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ChatType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get updatedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set updatedAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get userIds => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get memberCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set memberCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMemberCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearMemberCount() => $_clearField(8);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
