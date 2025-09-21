// This is a generated file - do not edit.
//
// Generated from sync/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getStateRequestDescriptor instead')
const GetStateRequest$json = {
  '1': 'GetStateRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStateRequestDescriptor = $convert
    .base64Decode('Cg9HZXRTdGF0ZVJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');

@$core.Deprecated('Use getStateResponseDescriptor instead')
const GetStateResponse$json = {
  '1': 'GetStateResponse',
  '2': [
    {'1': 'pts', '3': 1, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'unordered_pts', '3': 2, '4': 1, '5': 3, '10': 'unorderedPts'},
  ],
};

/// Descriptor for `GetStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStateResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTdGF0ZVJlc3BvbnNlEhAKA3B0cxgBIAEoA1IDcHRzEiMKDXVub3JkZXJlZF9wdHMYAi'
    'ABKANSDHVub3JkZXJlZFB0cw==');

@$core.Deprecated('Use getDifferenceRequestDescriptor instead')
const GetDifferenceRequest$json = {
  '1': 'GetDifferenceRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'pts', '3': 2, '4': 1, '5': 3, '10': 'pts'},
    {'1': 'unordered_pts', '3': 3, '4': 1, '5': 3, '10': 'unorderedPts'},
  ],
};

/// Descriptor for `GetDifferenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDifferenceRequestDescriptor = $convert.base64Decode(
    'ChRHZXREaWZmZXJlbmNlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSEAoDcHRzGA'
    'IgASgDUgNwdHMSIwoNdW5vcmRlcmVkX3B0cxgDIAEoA1IMdW5vcmRlcmVkUHRz');

@$core.Deprecated('Use getDifferenceResponseDescriptor instead')
const GetDifferenceResponse$json = {
  '1': 'GetDifferenceResponse',
  '2': [
    {'1': 'new_pts', '3': 1, '4': 1, '5': 3, '10': 'newPts'},
    {'1': 'new_unordered_pts', '3': 2, '4': 1, '5': 3, '10': 'newUnorderedPts'},
    {
      '1': 'updates',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.common.Update',
      '10': 'updates'
    },
  ],
};

/// Descriptor for `GetDifferenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDifferenceResponseDescriptor = $convert.base64Decode(
    'ChVHZXREaWZmZXJlbmNlUmVzcG9uc2USFwoHbmV3X3B0cxgBIAEoA1IGbmV3UHRzEioKEW5ld1'
    '91bm9yZGVyZWRfcHRzGAIgASgDUg9uZXdVbm9yZGVyZWRQdHMSKAoHdXBkYXRlcxgDIAMoCzIO'
    'LmNvbW1vbi5VcGRhdGVSB3VwZGF0ZXM=');

@$core.Deprecated('Use getSnapshotRequestDescriptor instead')
const GetSnapshotRequest$json = {
  '1': 'GetSnapshotRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'limit_per_chat', '3': 2, '4': 1, '5': 5, '10': 'limitPerChat'},
  ],
};

/// Descriptor for `GetSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSnapshotRequestDescriptor = $convert.base64Decode(
    'ChJHZXRTbmFwc2hvdFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEiQKDmxpbWl0X3'
    'Blcl9jaGF0GAIgASgFUgxsaW1pdFBlckNoYXQ=');

@$core.Deprecated('Use getSnapshotResponseDescriptor instead')
const GetSnapshotResponse$json = {
  '1': 'GetSnapshotResponse',
  '2': [
    {'1': 'new_pts', '3': 1, '4': 1, '5': 3, '10': 'newPts'},
    {'1': 'new_unordered_pts', '3': 2, '4': 1, '5': 3, '10': 'newUnorderedPts'},
    {
      '1': 'chats',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.common.ChatState',
      '10': 'chats'
    },
    {
      '1': 'profile',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.common.ProfileState',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `GetSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSnapshotResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTbmFwc2hvdFJlc3BvbnNlEhcKB25ld19wdHMYASABKANSBm5ld1B0cxIqChFuZXdfdW'
    '5vcmRlcmVkX3B0cxgCIAEoA1IPbmV3VW5vcmRlcmVkUHRzEicKBWNoYXRzGAMgAygLMhEuY29t'
    'bW9uLkNoYXRTdGF0ZVIFY2hhdHMSLgoHcHJvZmlsZRgEIAEoCzIULmNvbW1vbi5Qcm9maWxlU3'
    'RhdGVSB3Byb2ZpbGU=');
