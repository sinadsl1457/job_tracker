// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'postings_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostingsFilter {

 ApplicationStage? get stage; JobChannel? get channel; PostingSort get sort;
/// Create a copy of PostingsFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostingsFilterCopyWith<PostingsFilter> get copyWith => _$PostingsFilterCopyWithImpl<PostingsFilter>(this as PostingsFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PostingsFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostingsFilter&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.sort, _this.sort) || other.sort == _this.sort));
}


@override
int get hashCode {
  final _this = this as PostingsFilter;
  return Object.hash(runtimeType,_this.stage,_this.channel,_this.sort);
}

@override
String toString() {
  final _this = this as PostingsFilter;
  return 'PostingsFilter(stage: ${_this.stage}, channel: ${_this.channel}, sort: ${_this.sort})';
}


}

/// @nodoc
abstract mixin class $PostingsFilterCopyWith<$Res>  {
  factory $PostingsFilterCopyWith(PostingsFilter value, $Res Function(PostingsFilter) _then) = _$PostingsFilterCopyWithImpl;
@useResult
$Res call({
 ApplicationStage? stage, JobChannel? channel, PostingSort sort
});




}
/// @nodoc
class _$PostingsFilterCopyWithImpl<$Res>
    implements $PostingsFilterCopyWith<$Res> {
  _$PostingsFilterCopyWithImpl(this._self, this._then);

  final PostingsFilter _self;
  final $Res Function(PostingsFilter) _then;

/// Create a copy of PostingsFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = freezed,Object? channel = freezed,Object? sort = null,}) {
  return _then(PostingsFilter(
stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ApplicationStage?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as JobChannel?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as PostingSort,
  ));
}

}


/// Adds pattern-matching-related methods to [PostingsFilter].
extension PostingsFilterPatterns on PostingsFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostingsFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostingsFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostingsFilter value)  $default,){
final _that = this;
switch (_that) {
case _PostingsFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostingsFilter value)?  $default,){
final _that = this;
switch (_that) {
case _PostingsFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApplicationStage? stage,  JobChannel? channel,  PostingSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostingsFilter() when $default != null:
return $default(_that.stage,_that.channel,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApplicationStage? stage,  JobChannel? channel,  PostingSort sort)  $default,) {final _that = this;
switch (_that) {
case _PostingsFilter():
return $default(_that.stage,_that.channel,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApplicationStage? stage,  JobChannel? channel,  PostingSort sort)?  $default,) {final _that = this;
switch (_that) {
case _PostingsFilter() when $default != null:
return $default(_that.stage,_that.channel,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _PostingsFilter implements PostingsFilter {
  const _PostingsFilter({this.stage, this.channel, this.sort = PostingSort.deadlineSoon});
  

@override final  ApplicationStage? stage;
@override final  JobChannel? channel;
@override@JsonKey() final  PostingSort sort;

/// Create a copy of PostingsFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostingsFilterCopyWith<_PostingsFilter> get copyWith => __$PostingsFilterCopyWithImpl<_PostingsFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostingsFilter&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stage,channel,sort);
}

@override
String toString() {
    return 'PostingsFilter(stage: $stage, channel: $channel, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$PostingsFilterCopyWith<$Res> implements $PostingsFilterCopyWith<$Res> {
  factory _$PostingsFilterCopyWith(_PostingsFilter value, $Res Function(_PostingsFilter) _then) = __$PostingsFilterCopyWithImpl;
@override @useResult
$Res call({
 ApplicationStage? stage, JobChannel? channel, PostingSort sort
});




}
/// @nodoc
class __$PostingsFilterCopyWithImpl<$Res>
    implements _$PostingsFilterCopyWith<$Res> {
  __$PostingsFilterCopyWithImpl(this._self, this._then);

  final _PostingsFilter _self;
  final $Res Function(_PostingsFilter) _then;

/// Create a copy of PostingsFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = freezed,Object? channel = freezed,Object? sort = null,}) {
  return _then(_PostingsFilter(
stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ApplicationStage?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as JobChannel?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as PostingSort,
  ));
}


}

// dart format on
