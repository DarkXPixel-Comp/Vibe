// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chatTypeDescriptor instead')
const ChatType$json = {
  '1': 'ChatType',
  '2': [
    {'1': 'PRIVATE', '2': 0},
    {'1': 'GROUP', '2': 1},
    {'1': 'CHANNEL', '2': 2},
  ],
};

/// Descriptor for `ChatType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatTypeDescriptor = $convert.base64Decode(
    'CghDaGF0VHlwZRILCgdQUklWQVRFEAASCQoFR1JPVVAQARILCgdDSEFOTkVMEAI=');

@$core.Deprecated('Use deleteChatRequestDescriptor instead')
const DeleteChatRequest$json = {
  '1': 'DeleteChatRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `DeleteChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChatRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVDaGF0UmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQ=');

@$core.Deprecated('Use deleteChatResponseDescriptor instead')
const DeleteChatResponse$json = {
  '1': 'DeleteChatResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `DeleteChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChatResponseDescriptor = $convert.base64Decode(
    'ChJEZWxldGVDaGF0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1lcnJvcl'
    '9tZXNzYWdlGAIgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use createChatRequestDescriptor instead')
const CreateChatRequest$json = {
  '1': 'CreateChatRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.chat.ChatType', '10': 'type'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'creator_id', '3': 3, '4': 1, '5': 9, '10': 'creatorId'},
    {'1': 'user_ids', '3': 4, '4': 3, '5': 9, '10': 'userIds'},
  ],
};

/// Descriptor for `CreateChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChatRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVDaGF0UmVxdWVzdBIiCgR0eXBlGAEgASgOMg4uY2hhdC5DaGF0VHlwZVIEdHlwZR'
    'IUCgV0aXRsZRgCIAEoCVIFdGl0bGUSHQoKY3JlYXRvcl9pZBgDIAEoCVIJY3JlYXRvcklkEhkK'
    'CHVzZXJfaWRzGAQgAygJUgd1c2VySWRz');

@$core.Deprecated('Use createChatResponseDescriptor instead')
const CreateChatResponse$json = {
  '1': 'CreateChatResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'chat', '3': 2, '4': 1, '5': 11, '6': '.chat.Chat', '10': 'chat'},
    {'1': 'error_message', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `CreateChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChatResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVDaGF0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIeCgRjaGF0GA'
    'IgASgLMgouY2hhdC5DaGF0UgRjaGF0EiMKDWVycm9yX21lc3NhZ2UYAyABKAlSDGVycm9yTWVz'
    'c2FnZQ==');

@$core.Deprecated('Use addUserToChatRequestDescriptor instead')
const AddUserToChatRequest$json = {
  '1': 'AddUserToChatRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `AddUserToChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addUserToChatRequestDescriptor = $convert.base64Decode(
    'ChRBZGRVc2VyVG9DaGF0UmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQSFwoHdXNlcl'
    '9pZBgCIAEoCVIGdXNlcklk');

@$core.Deprecated('Use addUserToChatResponseDescriptor instead')
const AddUserToChatResponse$json = {
  '1': 'AddUserToChatResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `AddUserToChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addUserToChatResponseDescriptor = $convert.base64Decode(
    'ChVBZGRVc2VyVG9DaGF0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1lcn'
    'Jvcl9tZXNzYWdlGAIgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use getChatRequestDescriptor instead')
const GetChatRequest$json = {
  '1': 'GetChatRequest',
  '2': [
    {'1': 'chat_id', '3': 1, '4': 1, '5': 9, '10': 'chatId'},
  ],
};

/// Descriptor for `GetChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatRequestDescriptor = $convert
    .base64Decode('Cg5HZXRDaGF0UmVxdWVzdBIXCgdjaGF0X2lkGAEgASgJUgZjaGF0SWQ=');

@$core.Deprecated('Use getChatsRequestDescriptor instead')
const GetChatsRequest$json = {
  '1': 'GetChatsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetChatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatsRequestDescriptor = $convert
    .base64Decode('Cg9HZXRDaGF0c1JlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklk');

@$core.Deprecated('Use getChatsResponseDescriptor instead')
const GetChatsResponse$json = {
  '1': 'GetChatsResponse',
  '2': [
    {'1': 'chats', '3': 1, '4': 3, '5': 11, '6': '.chat.Chat', '10': 'chats'},
  ],
};

/// Descriptor for `GetChatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRDaGF0c1Jlc3BvbnNlEiAKBWNoYXRzGAEgAygLMgouY2hhdC5DaGF0UgVjaGF0cw==');

@$core.Deprecated('Use chatResponseDescriptor instead')
const ChatResponse$json = {
  '1': 'ChatResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'chat', '3': 3, '4': 1, '5': 11, '6': '.chat.Chat', '10': 'chat'},
  ],
};

/// Descriptor for `ChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatResponseDescriptor = $convert.base64Decode(
    'CgxDaGF0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1lcnJvcl9tZXNzYW'
    'dlGAIgASgJUgxlcnJvck1lc3NhZ2USHgoEY2hhdBgDIAEoCzIKLmNoYXQuQ2hhdFIEY2hhdA==');

@$core.Deprecated('Use listUserChatsRequestDescriptor instead')
const ListUserChatsRequest$json = {
  '1': 'ListUserChatsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListUserChatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserChatsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0VXNlckNoYXRzUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSFAoFbGltaX'
    'QYAiABKAVSBWxpbWl0EhYKBm9mZnNldBgDIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listUserChatResponseDescriptor instead')
const ListUserChatResponse$json = {
  '1': 'ListUserChatResponse',
  '2': [
    {'1': 'chats', '3': 1, '4': 3, '5': 11, '6': '.chat.Chat', '10': 'chats'},
  ],
};

/// Descriptor for `ListUserChatResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserChatResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0VXNlckNoYXRSZXNwb25zZRIgCgVjaGF0cxgBIAMoCzIKLmNoYXQuQ2hhdFIFY2hhdH'
    'M=');

@$core.Deprecated('Use chatDescriptor instead')
const Chat$json = {
  '1': 'Chat',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.chat.ChatType', '10': 'type'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'creator_id', '3': 4, '4': 1, '5': 9, '10': 'creatorId'},
    {'1': 'created_at', '3': 5, '4': 1, '5': 9, '10': 'createdAt'},
    {'1': 'updated_at', '3': 6, '4': 1, '5': 9, '10': 'updatedAt'},
    {'1': 'user_ids', '3': 7, '4': 3, '5': 9, '10': 'userIds'},
    {'1': 'member_count', '3': 8, '4': 1, '5': 5, '10': 'memberCount'},
  ],
};

/// Descriptor for `Chat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatDescriptor = $convert.base64Decode(
    'CgRDaGF0Eg4KAmlkGAEgASgJUgJpZBIiCgR0eXBlGAIgASgOMg4uY2hhdC5DaGF0VHlwZVIEdH'
    'lwZRIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSHQoKY3JlYXRvcl9pZBgEIAEoCVIJY3JlYXRvcklk'
    'Eh0KCmNyZWF0ZWRfYXQYBSABKAlSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GAYgASgJUgl1cG'
    'RhdGVkQXQSGQoIdXNlcl9pZHMYByADKAlSB3VzZXJJZHMSIQoMbWVtYmVyX2NvdW50GAggASgF'
    'UgttZW1iZXJDb3VudA==');
