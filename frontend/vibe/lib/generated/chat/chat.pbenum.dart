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

class ChatType extends $pb.ProtobufEnum {
  static const ChatType PRIVATE =
      ChatType._(0, _omitEnumNames ? '' : 'PRIVATE');
  static const ChatType GROUP = ChatType._(1, _omitEnumNames ? '' : 'GROUP');
  static const ChatType CHANNEL =
      ChatType._(2, _omitEnumNames ? '' : 'CHANNEL');

  static const $core.List<ChatType> values = <ChatType>[
    PRIVATE,
    GROUP,
    CHANNEL,
  ];

  static final $core.List<ChatType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ChatType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
