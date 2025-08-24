// This is a generated file - do not edit.
//
// Generated from message/message.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getDifferenceRequestDescriptor instead')
const GetDifferenceRequest$json = {
  '1': 'GetDifferenceRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'pts', '3': 2, '4': 1, '5': 3, '10': 'pts'},
  ],
};

/// Descriptor for `GetDifferenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDifferenceRequestDescriptor = $convert.base64Decode(
    'ChRHZXREaWZmZXJlbmNlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSEAoDcHRzGA'
    'IgASgDUgNwdHM=');

@$core.Deprecated('Use getDifferenceResponseDescriptor instead')
const GetDifferenceResponse$json = {
  '1': 'GetDifferenceResponse',
  '2': [
    {'1': 'new_pts', '3': 1, '4': 1, '5': 3, '10': 'newPts'},
    {
      '1': 'states',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.message.ChatState',
      '10': 'states'
    },
  ],
};

/// Descriptor for `GetDifferenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDifferenceResponseDescriptor = $convert.base64Decode(
    'ChVHZXREaWZmZXJlbmNlUmVzcG9uc2USFwoHbmV3X3B0cxgBIAEoA1IGbmV3UHRzEioKBnN0YX'
    'RlcxgCIAMoCzISLm1lc3NhZ2UuQ2hhdFN0YXRlUgZzdGF0ZXM=');

@$core.Deprecated('Use deleteMessageRequestDescriptor instead')
const DeleteMessageRequest$json = {
  '1': 'DeleteMessageRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'chat_id', '3': 2, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `DeleteMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMessageRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVNZXNzYWdlUmVxdWVzdBIdCgptZXNzYWdlX2lkGAEgASgJUgltZXNzYWdlSWQSFw'
    'oHY2hhdF9pZBgCIAEoCVIGY2hhdElk');

@$core.Deprecated('Use deleteMessageResponseDescriptor instead')
const DeleteMessageResponse$json = {
  '1': 'DeleteMessageResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMessageResponseDescriptor =
    $convert.base64Decode(
        'ChVEZWxldGVNZXNzYWdlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use listMessagesRequestDescriptor instead')
const ListMessagesRequest$json = {
  '1': 'ListMessagesRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'last_message_id', '3': 3, '4': 1, '5': 9, '10': 'lastMessageId'},
  ],
};

/// Descriptor for `ListMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMessagesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0TWVzc2FnZXNSZXF1ZXN0EhcKB2NoYXRfaWQYASABKAlSBmNoYXRJZBIUCgVsaW1pdB'
    'gCIAEoBVIFbGltaXQSJgoPbGFzdF9tZXNzYWdlX2lkGAMgASgJUg1sYXN0TWVzc2FnZUlk');

@$core.Deprecated('Use listMessageResponseDescriptor instead')
const ListMessageResponse$json = {
  '1': 'ListMessageResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.message.Message',
      '10': 'messages'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ListMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMessageResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0TWVzc2FnZVJlc3BvbnNlEiwKCG1lc3NhZ2VzGAEgAygLMhAubWVzc2FnZS5NZXNzYW'
    'dlUghtZXNzYWdlcxIYCgdzdWNjZXNzGAIgASgIUgdzdWNjZXNz');

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
  ],
};

/// Descriptor for `GetStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStateResponseDescriptor =
    $convert.base64Decode('ChBHZXRTdGF0ZVJlc3BvbnNlEhAKA3B0cxgBIAEoA1IDcHRz');

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
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.message.Message',
      '10': 'messages'
    },
    {
      '1': 'deleted_message_ids',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'deletedMessageIds'
    },
  ],
};

/// Descriptor for `ChatState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatStateDescriptor = $convert.base64Decode(
    'CglDaGF0U3RhdGUSFwoHY2hhdF9pZBgBIAEoCVIGY2hhdElkEiwKCG1lc3NhZ2VzGAMgAygLMh'
    'AubWVzc2FnZS5NZXNzYWdlUghtZXNzYWdlcxIuChNkZWxldGVkX21lc3NhZ2VfaWRzGAQgAygJ'
    'UhFkZWxldGVkTWVzc2FnZUlkcw==');

@$core.Deprecated('Use callEventDescriptor instead')
const CallEvent$json = {
  '1': 'CallEvent',
  '2': [
    {'1': 'call_id', '3': 1, '4': 1, '5': 9, '10': 'callId'},
    {'1': 'chat_id', '3': 2, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'initiator_id', '3': 3, '4': 1, '5': 9, '10': 'initiatorId'},
    {'1': 'event_type', '3': 4, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'timestamp', '3': 5, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `CallEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List callEventDescriptor = $convert.base64Decode(
    'CglDYWxsRXZlbnQSFwoHY2FsbF9pZBgBIAEoCVIGY2FsbElkEhcKB2NoYXRfaWQYAiABKAlSBm'
    'NoYXRJZBIhCgxpbml0aWF0b3JfaWQYAyABKAlSC2luaXRpYXRvcklkEh0KCmV2ZW50X3R5cGUY'
    'BCABKAlSCWV2ZW50VHlwZRIcCgl0aW1lc3RhbXAYBSABKAlSCXRpbWVzdGFtcA==');
