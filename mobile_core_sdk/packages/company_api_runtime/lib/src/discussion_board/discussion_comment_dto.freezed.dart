// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discussion_comment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiscussionQuoteDto {

@JsonKey(fromJson: _toNullableInt) int? get id; String get username; String? get avatar; String get content;@JsonKey(fromJson: _toStringList) List<String> get imageUrls; String get createTime;
/// Create a copy of DiscussionQuoteDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscussionQuoteDtoCopyWith<DiscussionQuoteDto> get copyWith => _$DiscussionQuoteDtoCopyWithImpl<DiscussionQuoteDto>(this as DiscussionQuoteDto, _$identity);

  /// Serializes this DiscussionQuoteDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscussionQuoteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,content,const DeepCollectionEquality().hash(imageUrls),createTime);

@override
String toString() {
  return 'DiscussionQuoteDto(id: $id, username: $username, avatar: $avatar, content: $content, imageUrls: $imageUrls, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $DiscussionQuoteDtoCopyWith<$Res>  {
  factory $DiscussionQuoteDtoCopyWith(DiscussionQuoteDto value, $Res Function(DiscussionQuoteDto) _then) = _$DiscussionQuoteDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toNullableInt) int? id, String username, String? avatar, String content,@JsonKey(fromJson: _toStringList) List<String> imageUrls, String createTime
});




}
/// @nodoc
class _$DiscussionQuoteDtoCopyWithImpl<$Res>
    implements $DiscussionQuoteDtoCopyWith<$Res> {
  _$DiscussionQuoteDtoCopyWithImpl(this._self, this._then);

  final DiscussionQuoteDto _self;
  final $Res Function(DiscussionQuoteDto) _then;

/// Create a copy of DiscussionQuoteDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? username = null,Object? avatar = freezed,Object? content = null,Object? imageUrls = null,Object? createTime = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscussionQuoteDto].
extension DiscussionQuoteDtoPatterns on DiscussionQuoteDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscussionQuoteDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscussionQuoteDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscussionQuoteDto value)  $default,){
final _that = this;
switch (_that) {
case _DiscussionQuoteDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscussionQuoteDto value)?  $default,){
final _that = this;
switch (_that) {
case _DiscussionQuoteDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toNullableInt)  int? id,  String username,  String? avatar,  String content, @JsonKey(fromJson: _toStringList)  List<String> imageUrls,  String createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscussionQuoteDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.content,_that.imageUrls,_that.createTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toNullableInt)  int? id,  String username,  String? avatar,  String content, @JsonKey(fromJson: _toStringList)  List<String> imageUrls,  String createTime)  $default,) {final _that = this;
switch (_that) {
case _DiscussionQuoteDto():
return $default(_that.id,_that.username,_that.avatar,_that.content,_that.imageUrls,_that.createTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _toNullableInt)  int? id,  String username,  String? avatar,  String content, @JsonKey(fromJson: _toStringList)  List<String> imageUrls,  String createTime)?  $default,) {final _that = this;
switch (_that) {
case _DiscussionQuoteDto() when $default != null:
return $default(_that.id,_that.username,_that.avatar,_that.content,_that.imageUrls,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscussionQuoteDto implements DiscussionQuoteDto {
  const _DiscussionQuoteDto({@JsonKey(fromJson: _toNullableInt) this.id, this.username = '', this.avatar, this.content = '', @JsonKey(fromJson: _toStringList) final  List<String> imageUrls = const <String>[], this.createTime = ''}): _imageUrls = imageUrls;
  factory _DiscussionQuoteDto.fromJson(Map<String, dynamic> json) => _$DiscussionQuoteDtoFromJson(json);

@override@JsonKey(fromJson: _toNullableInt) final  int? id;
@override@JsonKey() final  String username;
@override final  String? avatar;
@override@JsonKey() final  String content;
 final  List<String> _imageUrls;
@override@JsonKey(fromJson: _toStringList) List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  String createTime;

/// Create a copy of DiscussionQuoteDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscussionQuoteDtoCopyWith<_DiscussionQuoteDto> get copyWith => __$DiscussionQuoteDtoCopyWithImpl<_DiscussionQuoteDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscussionQuoteDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscussionQuoteDto&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar,content,const DeepCollectionEquality().hash(_imageUrls),createTime);

@override
String toString() {
  return 'DiscussionQuoteDto(id: $id, username: $username, avatar: $avatar, content: $content, imageUrls: $imageUrls, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$DiscussionQuoteDtoCopyWith<$Res> implements $DiscussionQuoteDtoCopyWith<$Res> {
  factory _$DiscussionQuoteDtoCopyWith(_DiscussionQuoteDto value, $Res Function(_DiscussionQuoteDto) _then) = __$DiscussionQuoteDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toNullableInt) int? id, String username, String? avatar, String content,@JsonKey(fromJson: _toStringList) List<String> imageUrls, String createTime
});




}
/// @nodoc
class __$DiscussionQuoteDtoCopyWithImpl<$Res>
    implements _$DiscussionQuoteDtoCopyWith<$Res> {
  __$DiscussionQuoteDtoCopyWithImpl(this._self, this._then);

  final _DiscussionQuoteDto _self;
  final $Res Function(_DiscussionQuoteDto) _then;

/// Create a copy of DiscussionQuoteDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? username = null,Object? avatar = freezed,Object? content = null,Object? imageUrls = null,Object? createTime = null,}) {
  return _then(_DiscussionQuoteDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DiscussionCommentDto {

@JsonKey(fromJson: _toNullableInt) int? get id;@JsonKey(fromJson: _toNullableInt) int? get userId; String get username; String? get avatar; String get content;@JsonKey(fromJson: _toStringList) List<String> get imageUrls; String get createTime;@JsonKey(fromJson: _toNullableInt) int? get projectId; String get projectName;@JsonKey(fromJson: _quoteFromJson) DiscussionQuoteDto? get quote;
/// Create a copy of DiscussionCommentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscussionCommentDtoCopyWith<DiscussionCommentDto> get copyWith => _$DiscussionCommentDtoCopyWithImpl<DiscussionCommentDto>(this as DiscussionCommentDto, _$identity);

  /// Serializes this DiscussionCommentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscussionCommentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.quote, quote) || other.quote == quote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,avatar,content,const DeepCollectionEquality().hash(imageUrls),createTime,projectId,projectName,quote);

@override
String toString() {
  return 'DiscussionCommentDto(id: $id, userId: $userId, username: $username, avatar: $avatar, content: $content, imageUrls: $imageUrls, createTime: $createTime, projectId: $projectId, projectName: $projectName, quote: $quote)';
}


}

/// @nodoc
abstract mixin class $DiscussionCommentDtoCopyWith<$Res>  {
  factory $DiscussionCommentDtoCopyWith(DiscussionCommentDto value, $Res Function(DiscussionCommentDto) _then) = _$DiscussionCommentDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toNullableInt) int? id,@JsonKey(fromJson: _toNullableInt) int? userId, String username, String? avatar, String content,@JsonKey(fromJson: _toStringList) List<String> imageUrls, String createTime,@JsonKey(fromJson: _toNullableInt) int? projectId, String projectName,@JsonKey(fromJson: _quoteFromJson) DiscussionQuoteDto? quote
});


$DiscussionQuoteDtoCopyWith<$Res>? get quote;

}
/// @nodoc
class _$DiscussionCommentDtoCopyWithImpl<$Res>
    implements $DiscussionCommentDtoCopyWith<$Res> {
  _$DiscussionCommentDtoCopyWithImpl(this._self, this._then);

  final DiscussionCommentDto _self;
  final $Res Function(DiscussionCommentDto) _then;

/// Create a copy of DiscussionCommentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? username = null,Object? avatar = freezed,Object? content = null,Object? imageUrls = null,Object? createTime = null,Object? projectId = freezed,Object? projectName = null,Object? quote = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as DiscussionQuoteDto?,
  ));
}
/// Create a copy of DiscussionCommentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscussionQuoteDtoCopyWith<$Res>? get quote {
    if (_self.quote == null) {
    return null;
  }

  return $DiscussionQuoteDtoCopyWith<$Res>(_self.quote!, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscussionCommentDto].
extension DiscussionCommentDtoPatterns on DiscussionCommentDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscussionCommentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscussionCommentDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscussionCommentDto value)  $default,){
final _that = this;
switch (_that) {
case _DiscussionCommentDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscussionCommentDto value)?  $default,){
final _that = this;
switch (_that) {
case _DiscussionCommentDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toNullableInt)  int? id, @JsonKey(fromJson: _toNullableInt)  int? userId,  String username,  String? avatar,  String content, @JsonKey(fromJson: _toStringList)  List<String> imageUrls,  String createTime, @JsonKey(fromJson: _toNullableInt)  int? projectId,  String projectName, @JsonKey(fromJson: _quoteFromJson)  DiscussionQuoteDto? quote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscussionCommentDto() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.avatar,_that.content,_that.imageUrls,_that.createTime,_that.projectId,_that.projectName,_that.quote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toNullableInt)  int? id, @JsonKey(fromJson: _toNullableInt)  int? userId,  String username,  String? avatar,  String content, @JsonKey(fromJson: _toStringList)  List<String> imageUrls,  String createTime, @JsonKey(fromJson: _toNullableInt)  int? projectId,  String projectName, @JsonKey(fromJson: _quoteFromJson)  DiscussionQuoteDto? quote)  $default,) {final _that = this;
switch (_that) {
case _DiscussionCommentDto():
return $default(_that.id,_that.userId,_that.username,_that.avatar,_that.content,_that.imageUrls,_that.createTime,_that.projectId,_that.projectName,_that.quote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _toNullableInt)  int? id, @JsonKey(fromJson: _toNullableInt)  int? userId,  String username,  String? avatar,  String content, @JsonKey(fromJson: _toStringList)  List<String> imageUrls,  String createTime, @JsonKey(fromJson: _toNullableInt)  int? projectId,  String projectName, @JsonKey(fromJson: _quoteFromJson)  DiscussionQuoteDto? quote)?  $default,) {final _that = this;
switch (_that) {
case _DiscussionCommentDto() when $default != null:
return $default(_that.id,_that.userId,_that.username,_that.avatar,_that.content,_that.imageUrls,_that.createTime,_that.projectId,_that.projectName,_that.quote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscussionCommentDto implements DiscussionCommentDto {
  const _DiscussionCommentDto({@JsonKey(fromJson: _toNullableInt) this.id, @JsonKey(fromJson: _toNullableInt) this.userId, this.username = '', this.avatar, this.content = '', @JsonKey(fromJson: _toStringList) final  List<String> imageUrls = const <String>[], this.createTime = '', @JsonKey(fromJson: _toNullableInt) this.projectId, this.projectName = '', @JsonKey(fromJson: _quoteFromJson) this.quote}): _imageUrls = imageUrls;
  factory _DiscussionCommentDto.fromJson(Map<String, dynamic> json) => _$DiscussionCommentDtoFromJson(json);

@override@JsonKey(fromJson: _toNullableInt) final  int? id;
@override@JsonKey(fromJson: _toNullableInt) final  int? userId;
@override@JsonKey() final  String username;
@override final  String? avatar;
@override@JsonKey() final  String content;
 final  List<String> _imageUrls;
@override@JsonKey(fromJson: _toStringList) List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  String createTime;
@override@JsonKey(fromJson: _toNullableInt) final  int? projectId;
@override@JsonKey() final  String projectName;
@override@JsonKey(fromJson: _quoteFromJson) final  DiscussionQuoteDto? quote;

/// Create a copy of DiscussionCommentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscussionCommentDtoCopyWith<_DiscussionCommentDto> get copyWith => __$DiscussionCommentDtoCopyWithImpl<_DiscussionCommentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscussionCommentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscussionCommentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.createTime, createTime) || other.createTime == createTime)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.quote, quote) || other.quote == quote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,username,avatar,content,const DeepCollectionEquality().hash(_imageUrls),createTime,projectId,projectName,quote);

@override
String toString() {
  return 'DiscussionCommentDto(id: $id, userId: $userId, username: $username, avatar: $avatar, content: $content, imageUrls: $imageUrls, createTime: $createTime, projectId: $projectId, projectName: $projectName, quote: $quote)';
}


}

/// @nodoc
abstract mixin class _$DiscussionCommentDtoCopyWith<$Res> implements $DiscussionCommentDtoCopyWith<$Res> {
  factory _$DiscussionCommentDtoCopyWith(_DiscussionCommentDto value, $Res Function(_DiscussionCommentDto) _then) = __$DiscussionCommentDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toNullableInt) int? id,@JsonKey(fromJson: _toNullableInt) int? userId, String username, String? avatar, String content,@JsonKey(fromJson: _toStringList) List<String> imageUrls, String createTime,@JsonKey(fromJson: _toNullableInt) int? projectId, String projectName,@JsonKey(fromJson: _quoteFromJson) DiscussionQuoteDto? quote
});


@override $DiscussionQuoteDtoCopyWith<$Res>? get quote;

}
/// @nodoc
class __$DiscussionCommentDtoCopyWithImpl<$Res>
    implements _$DiscussionCommentDtoCopyWith<$Res> {
  __$DiscussionCommentDtoCopyWithImpl(this._self, this._then);

  final _DiscussionCommentDto _self;
  final $Res Function(_DiscussionCommentDto) _then;

/// Create a copy of DiscussionCommentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? username = null,Object? avatar = freezed,Object? content = null,Object? imageUrls = null,Object? createTime = null,Object? projectId = freezed,Object? projectName = null,Object? quote = freezed,}) {
  return _then(_DiscussionCommentDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createTime: null == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as int?,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as DiscussionQuoteDto?,
  ));
}

/// Create a copy of DiscussionCommentDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscussionQuoteDtoCopyWith<$Res>? get quote {
    if (_self.quote == null) {
    return null;
  }

  return $DiscussionQuoteDtoCopyWith<$Res>(_self.quote!, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}

// dart format on
