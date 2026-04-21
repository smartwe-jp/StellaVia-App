// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiscussionQuoteDto _$DiscussionQuoteDtoFromJson(Map<String, dynamic> json) =>
    _DiscussionQuoteDto(
      id: _toNullableInt(json['id']),
      username: json['username'] as String? ?? '',
      avatar: json['avatar'] as String?,
      content: json['content'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
    );

Map<String, dynamic> _$DiscussionQuoteDtoToJson(_DiscussionQuoteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
      'content': instance.content,
      'createTime': instance.createTime,
    };

_DiscussionCommentDto _$DiscussionCommentDtoFromJson(
  Map<String, dynamic> json,
) => _DiscussionCommentDto(
  id: _toNullableInt(json['id']),
  userId: _toNullableInt(json['userId']),
  username: json['username'] as String? ?? '',
  avatar: json['avatar'] as String?,
  content: json['content'] as String? ?? '',
  createTime: json['createTime'] as String? ?? '',
  projectId: _toNullableInt(json['projectId']),
  projectName: json['projectName'] as String? ?? '',
  quote: _quoteFromJson(json['quote']),
);

Map<String, dynamic> _$DiscussionCommentDtoToJson(
  _DiscussionCommentDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'username': instance.username,
  'avatar': instance.avatar,
  'content': instance.content,
  'createTime': instance.createTime,
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'quote': instance.quote,
};
