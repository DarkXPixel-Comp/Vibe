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
      '6': '.common.Message',
      '10': 'messages'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ListMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMessageResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0TWVzc2FnZVJlc3BvbnNlEisKCG1lc3NhZ2VzGAEgAygLMg8uY29tbW9uLk1lc3NhZ2'
    'VSCG1lc3NhZ2VzEhgKB3N1Y2Nlc3MYAiABKAhSB3N1Y2Nlc3M=');
