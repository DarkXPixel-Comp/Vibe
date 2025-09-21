// This is a generated file - do not edit.
//
// Generated from user/user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetUserByPhoneRequest extends $pb.GeneratedMessage {
  factory GetUserByPhoneRequest({
    $core.String? phone,
  }) {
    final result = create();
    if (phone != null) result.phone = phone;
    return result;
  }

  GetUserByPhoneRequest._();

  factory GetUserByPhoneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserByPhoneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserByPhoneRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserByPhoneRequest clone() =>
      GetUserByPhoneRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserByPhoneRequest copyWith(
          void Function(GetUserByPhoneRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserByPhoneRequest))
          as GetUserByPhoneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserByPhoneRequest create() => GetUserByPhoneRequest._();
  @$core.override
  GetUserByPhoneRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserByPhoneRequest> createRepeated() =>
      $pb.PbList<GetUserByPhoneRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUserByPhoneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserByPhoneRequest>(create);
  static GetUserByPhoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => $_clearField(1);
}

class UserResponse extends $pb.GeneratedMessage {
  factory UserResponse({
    $core.bool? success,
    User? user,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (user != null) result.user = user;
    return result;
  }

  UserResponse._();

  factory UserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<User>(2, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserResponse clone() => UserResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserResponse copyWith(void Function(UserResponse) updates) =>
      super.copyWith((message) => updates(message as UserResponse))
          as UserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserResponse create() => UserResponse._();
  @$core.override
  UserResponse createEmptyInstance() => create();
  static $pb.PbList<UserResponse> createRepeated() =>
      $pb.PbList<UserResponse>();
  @$core.pragma('dart2js:noInline')
  static UserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserResponse>(create);
  static UserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(User value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  User ensureUser() => $_ensure(1);
}

class GetOrCreateUserRequest extends $pb.GeneratedMessage {
  factory GetOrCreateUserRequest({
    $core.String? phone,
  }) {
    final result = create();
    if (phone != null) result.phone = phone;
    return result;
  }

  GetOrCreateUserRequest._();

  factory GetOrCreateUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOrCreateUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrCreateUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrCreateUserRequest clone() =>
      GetOrCreateUserRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrCreateUserRequest copyWith(
          void Function(GetOrCreateUserRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrCreateUserRequest))
          as GetOrCreateUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOrCreateUserRequest create() => GetOrCreateUserRequest._();
  @$core.override
  GetOrCreateUserRequest createEmptyInstance() => create();
  static $pb.PbList<GetOrCreateUserRequest> createRepeated() =>
      $pb.PbList<GetOrCreateUserRequest>();
  @$core.pragma('dart2js:noInline')
  static GetOrCreateUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOrCreateUserRequest>(create);
  static GetOrCreateUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => $_clearField(1);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? userId,
    $core.String? phone,
    $core.String? userName,
    $core.String? createdAt,
    $core.String? updatedAt,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (phone != null) result.phone = phone;
    if (userName != null) result.userName = userName;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  User._();

  factory User.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory User.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'userName')
    ..aOS(4, _omitFieldNames ? '' : 'createdAt')
    ..aOS(5, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  @$core.override
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userName => $_getSZ(2);
  @$pb.TagNumber(3)
  set userName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get createdAt => $_getSZ(3);
  @$pb.TagNumber(4)
  set createdAt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get updatedAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set updatedAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
