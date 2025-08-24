// This is a generated file - do not edit.
//
// Generated from common/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'chat_id', '3': 2, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    {'1': 'payload', '3': 5, '4': 1, '5': 9, '10': 'payload'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEg4KAmlkGAEgASgJUgJpZBIXCgdjaGF0X2lkGAIgASgJUgZjaGF0SWQSFwoHdX'
    'Nlcl9pZBgDIAEoCVIGdXNlcklkEhIKBHR5cGUYBCABKAlSBHR5cGUSGAoHcGF5bG9hZBgFIAEo'
    'CVIHcGF5bG9hZBIcCgl0aW1lc3RhbXAYBiABKAlSCXRpbWVzdGFtcA==');

@$core.Deprecated('Use chatStateDescriptor instead')
const ChatState$json = {
  '1': 'ChatState',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {
      '1': 'messages',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.common.Message',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `ChatState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatStateDescriptor = $convert.base64Decode(
    'CglDaGF0U3RhdGUSFwoHY2hhdF9pZBgBIAEoCVIGY2hhdElkEisKCG1lc3NhZ2VzGAIgAygLMg'
    '8uY29tbW9uLk1lc3NhZ2VSCG1lc3NhZ2Vz');

@$core.Deprecated('Use updateDescriptor instead')
const Update$json = {
  '1': 'Update',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'payload', '3': 4, '4': 1, '5': 9, '10': 'payload'},
    {'1': 'pts', '3': 5, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'unordered_pts', '3': 6, '4': 1, '5': 3, '10': 'unorderedPts'},
    {'1': 'timestamp', '3': 7, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `Update`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDescriptor = $convert.base64Decode(
    'CgZVcGRhdGUSDgoCaWQYASABKAlSAmlkEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZBISCgR0eX'
    'BlGAMgASgJUgR0eXBlEhgKB3BheWxvYWQYBCABKAlSB3BheWxvYWQSEAoDcHRzGAUgASgDUgNw'
    'dHMSIwoNdW5vcmRlcmVkX3B0cxgGIAEoA1IMdW5vcmRlcmVkUHRzEhwKCXRpbWVzdGFtcBgHIA'
    'EoCVIJdGltZXN0YW1w');

@$core.Deprecated('Use profileStateDescriptor instead')
const ProfileState$json = {
  '1': 'ProfileState',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'avatar_url', '3': 3, '4': 1, '5': 9, '10': 'avatarUrl'},
  ],
};

/// Descriptor for `ProfileState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileStateDescriptor = $convert.base64Decode(
    'CgxQcm9maWxlU3RhdGUSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSHQoKYXZhdGFyX3VybBgDIAEoCVIJYXZhdGFyVXJs');
