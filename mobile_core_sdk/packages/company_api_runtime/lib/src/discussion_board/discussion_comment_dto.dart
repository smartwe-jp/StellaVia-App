// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'discussion_comment_dto.freezed.dart';
part 'discussion_comment_dto.g.dart';

@freezed
abstract class DiscussionQuoteDto with _$DiscussionQuoteDto {
  const factory DiscussionQuoteDto({
    @JsonKey(fromJson: _toNullableInt) int? id,
    @Default('') String username,
    String? avatar,
    @Default('') String content,
    @Default('') String createTime,
  }) = _DiscussionQuoteDto;

  factory DiscussionQuoteDto.fromJson(Map<String, dynamic> json) =>
      _$DiscussionQuoteDtoFromJson(json);
}

@freezed
abstract class DiscussionCommentDto with _$DiscussionCommentDto {
  const factory DiscussionCommentDto({
    @JsonKey(fromJson: _toNullableInt) int? id,
    @JsonKey(fromJson: _toNullableInt) int? userId,
    @Default('') String username,
    String? avatar,
    @Default('') String content,
    @Default('') String createTime,
    @JsonKey(fromJson: _toNullableInt) int? projectId,
    @Default('') String projectName,
    @JsonKey(fromJson: _quoteFromJson) DiscussionQuoteDto? quote,
  }) = _DiscussionCommentDto;

  factory DiscussionCommentDto.fromJson(Map<String, dynamic> json) =>
      _$DiscussionCommentDtoFromJson(json);
}

int? _toNullableInt(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

DiscussionQuoteDto? _quoteFromJson(Object? value) {
  if (value is Map<String, dynamic>) {
    return DiscussionQuoteDto.fromJson(value);
  }
  if (value is Map) {
    return DiscussionQuoteDto.fromJson(Map<String, dynamic>.from(value));
  }
  return null;
}
