// This is a generated file - do not edit.
//
// Generated from user/user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getUserByPhoneRequestDescriptor instead')
const GetUserByPhoneRequest$json = {
  '1': 'GetUserByPhoneRequest',
  '2': [
    {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `GetUserByPhoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserByPhoneRequestDescriptor =
    $convert.base64Decode(
        'ChVHZXRVc2VyQnlQaG9uZVJlcXVlc3QSFAoFcGhvbmUYASABKAlSBXBob25l');

@$core.Deprecated('Use userResponseDescriptor instead')
const UserResponse$json = {
  '1': 'UserResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'user', '3': 2, '4': 1, '5': 11, '6': '.user.User', '10': 'user'},
  ],
};

/// Descriptor for `UserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userResponseDescriptor = $convert.base64Decode(
    'CgxVc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIeCgR1c2VyGAIgASgLMg'
    'oudXNlci5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use getOrCreateUserRequestDescriptor instead')
const GetOrCreateUserRequest$json = {
  '1': 'GetOrCreateUserRequest',
  '2': [
    {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `GetOrCreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrCreateUserRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRPckNyZWF0ZVVzZXJSZXF1ZXN0EhQKBXBob25lGAEgASgJUgVwaG9uZQ==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'created_at', '3': 4, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 5, '4': 1, '5': 9, '10': 'updatedAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIUCgVwaG9uZRgCIAEoCVIFcGhvbmUSGw'
    'oJdXNlcl9uYW1lGAMgASgJUgh1c2VyTmFtZRIdCgpjcmVhdGVkX2F0GAQgASgJUgljcmVhdGVk'
    'QXQSHQoKdXBkYXRlZF9hdBgFIAEoCVIJdXBkYXRlZEF0');
