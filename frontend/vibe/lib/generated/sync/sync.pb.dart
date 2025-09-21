// This is a generated file - do not edit.
//
// Generated from sync/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../common/types.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetStateRequest extends $pb.GeneratedMessage {
  factory GetStateRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetStateRequest._();

  factory GetStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sync'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStateRequest clone() => GetStateRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStateRequest copyWith(void Function(GetStateRequest) updates) =>
      super.copyWith((message) => updates(message as GetStateRequest))
          as GetStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStateRequest create() => GetStateRequest._();
  @$core.override
  GetStateRequest createEmptyInstance() => create();
  static $pb.PbList<GetStateRequest> createRepeated() =>
      $pb.PbList<GetStateRequest>();
  @$core.pragma('dart2js:noInline')
  static GetStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStateRequest>(create);
  static GetStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class GetStateResponse extends $pb.GeneratedMessage {
  factory GetStateResponse({
    $fixnum.Int64? pts,
    $fixnum.Int64? unorderedPts,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (unorderedPts != null) result.unorderedPts = unorderedPts;
    return result;
  }

  GetStateResponse._();

  factory GetStateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sync'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aInt64(2, _omitFieldNames ? '' : 'unorderedPts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStateResponse clone() => GetStateResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStateResponse copyWith(void Function(GetStateResponse) updates) =>
      super.copyWith((message) => updates(message as GetStateResponse))
          as GetStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStateResponse create() => GetStateResponse._();
  @$core.override
  GetStateResponse createEmptyInstance() => create();
  static $pb.PbList<GetStateResponse> createRepeated() =>
      $pb.PbList<GetStateResponse>();
  @$core.pragma('dart2js:noInline')
  static GetStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStateResponse>(create);
  static GetStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get unorderedPts => $_getI64(1);
  @$pb.TagNumber(2)
  set unorderedPts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnorderedPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnorderedPts() => $_clearField(2);
}

class GetDifferenceRequest extends $pb.GeneratedMessage {
  factory GetDifferenceRequest({
    $core.String? userId,
    $fixnum.Int64? pts,
    $fixnum.Int64? unorderedPts,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (pts != null) result.pts = pts;
    if (unorderedPts != null) result.unorderedPts = unorderedPts;
    return result;
  }

  GetDifferenceRequest._();

  factory GetDifferenceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifferenceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDifferenceRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sync'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aInt64(2, _omitFieldNames ? '' : 'pts')
    ..aInt64(3, _omitFieldNames ? '' : 'unorderedPts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifferenceRequest clone() =>
      GetDifferenceRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifferenceRequest copyWith(void Function(GetDifferenceRequest) updates) =>
      super.copyWith((message) => updates(message as GetDifferenceRequest))
          as GetDifferenceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifferenceRequest create() => GetDifferenceRequest._();
  @$core.override
  GetDifferenceRequest createEmptyInstance() => create();
  static $pb.PbList<GetDifferenceRequest> createRepeated() =>
      $pb.PbList<GetDifferenceRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDifferenceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDifferenceRequest>(create);
  static GetDifferenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pts => $_getI64(1);
  @$pb.TagNumber(2)
  set pts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearPts() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get unorderedPts => $_getI64(2);
  @$pb.TagNumber(3)
  set unorderedPts($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnorderedPts() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnorderedPts() => $_clearField(3);
}

class GetDifferenceResponse extends $pb.GeneratedMessage {
  factory GetDifferenceResponse({
    $fixnum.Int64? newPts,
    $fixnum.Int64? newUnorderedPts,
    $core.Iterable<$1.Update>? updates,
  }) {
    final result = create();
    if (newPts != null) result.newPts = newPts;
    if (newUnorderedPts != null) result.newUnorderedPts = newUnorderedPts;
    if (updates != null) result.updates.addAll(updates);
    return result;
  }

  GetDifferenceResponse._();

  factory GetDifferenceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifferenceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDifferenceResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sync'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'newPts')
    ..aInt64(2, _omitFieldNames ? '' : 'newUnorderedPts')
    ..pc<$1.Update>(3, _omitFieldNames ? '' : 'updates', $pb.PbFieldType.PM,
        subBuilder: $1.Update.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifferenceResponse clone() =>
      GetDifferenceResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifferenceResponse copyWith(
          void Function(GetDifferenceResponse) updates) =>
      super.copyWith((message) => updates(message as GetDifferenceResponse))
          as GetDifferenceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifferenceResponse create() => GetDifferenceResponse._();
  @$core.override
  GetDifferenceResponse createEmptyInstance() => create();
  static $pb.PbList<GetDifferenceResponse> createRepeated() =>
      $pb.PbList<GetDifferenceResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDifferenceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDifferenceResponse>(create);
  static GetDifferenceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get newPts => $_getI64(0);
  @$pb.TagNumber(1)
  set newPts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNewPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get newUnorderedPts => $_getI64(1);
  @$pb.TagNumber(2)
  set newUnorderedPts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewUnorderedPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewUnorderedPts() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$1.Update> get updates => $_getList(2);
}

class GetSnapshotRequest extends $pb.GeneratedMessage {
  factory GetSnapshotRequest({
    $core.String? userId,
    $core.int? limitPerChat,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (limitPerChat != null) result.limitPerChat = limitPerChat;
    return result;
  }

  GetSnapshotRequest._();

  factory GetSnapshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSnapshotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sync'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limitPerChat', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotRequest clone() => GetSnapshotRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotRequest copyWith(void Function(GetSnapshotRequest) updates) =>
      super.copyWith((message) => updates(message as GetSnapshotRequest))
          as GetSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSnapshotRequest create() => GetSnapshotRequest._();
  @$core.override
  GetSnapshotRequest createEmptyInstance() => create();
  static $pb.PbList<GetSnapshotRequest> createRepeated() =>
      $pb.PbList<GetSnapshotRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSnapshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSnapshotRequest>(create);
  static GetSnapshotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limitPerChat => $_getIZ(1);
  @$pb.TagNumber(2)
  set limitPerChat($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimitPerChat() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimitPerChat() => $_clearField(2);
}

class GetSnapshotResponse extends $pb.GeneratedMessage {
  factory GetSnapshotResponse({
    $fixnum.Int64? newPts,
    $fixnum.Int64? newUnorderedPts,
    $core.Iterable<$1.ChatState>? chats,
    $1.ProfileState? profile,
  }) {
    final result = create();
    if (newPts != null) result.newPts = newPts;
    if (newUnorderedPts != null) result.newUnorderedPts = newUnorderedPts;
    if (chats != null) result.chats.addAll(chats);
    if (profile != null) result.profile = profile;
    return result;
  }

  GetSnapshotResponse._();

  factory GetSnapshotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSnapshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSnapshotResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'sync'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'newPts')
    ..aInt64(2, _omitFieldNames ? '' : 'newUnorderedPts')
    ..pc<$1.ChatState>(3, _omitFieldNames ? '' : 'chats', $pb.PbFieldType.PM,
        subBuilder: $1.ChatState.create)
    ..aOM<$1.ProfileState>(4, _omitFieldNames ? '' : 'profile',
        subBuilder: $1.ProfileState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotResponse clone() => GetSnapshotResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotResponse copyWith(void Function(GetSnapshotResponse) updates) =>
      super.copyWith((message) => updates(message as GetSnapshotResponse))
          as GetSnapshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSnapshotResponse create() => GetSnapshotResponse._();
  @$core.override
  GetSnapshotResponse createEmptyInstance() => create();
  static $pb.PbList<GetSnapshotResponse> createRepeated() =>
      $pb.PbList<GetSnapshotResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSnapshotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSnapshotResponse>(create);
  static GetSnapshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get newPts => $_getI64(0);
  @$pb.TagNumber(1)
  set newPts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNewPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get newUnorderedPts => $_getI64(1);
  @$pb.TagNumber(2)
  set newUnorderedPts($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewUnorderedPts() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewUnorderedPts() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$1.ChatState> get chats => $_getList(2);

  @$pb.TagNumber(4)
  $1.ProfileState get profile => $_getN(3);
  @$pb.TagNumber(4)
  set profile($1.ProfileState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProfile() => $_has(3);
  @$pb.TagNumber(4)
  void clearProfile() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.ProfileState ensureProfile() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
