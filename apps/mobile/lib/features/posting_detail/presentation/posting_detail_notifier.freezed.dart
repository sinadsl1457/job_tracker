// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'posting_detail_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostingDetail {

 JobPosting get posting; List<StageEvent> get events;
/// Create a copy of PostingDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostingDetailCopyWith<PostingDetail> get copyWith => _$PostingDetailCopyWithImpl<PostingDetail>(this as PostingDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PostingDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostingDetail&&(identical(other.posting, _this.posting) || other.posting == _this.posting)&&const DeepCollectionEquality().equals(other.events, _this.events));
}


@override
int get hashCode {
  final _this = this as PostingDetail;
  return Object.hash(runtimeType,_this.posting,const DeepCollectionEquality().hash(_this.events));
}

@override
String toString() {
  final _this = this as PostingDetail;
  return 'PostingDetail(posting: ${_this.posting}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $PostingDetailCopyWith<$Res>  {
  factory $PostingDetailCopyWith(PostingDetail value, $Res Function(PostingDetail) _then) = _$PostingDetailCopyWithImpl;
@useResult
$Res call({
 JobPosting posting, List<StageEvent> events
});


$JobPostingCopyWith<$Res> get posting;

}
/// @nodoc
class _$PostingDetailCopyWithImpl<$Res>
    implements $PostingDetailCopyWith<$Res> {
  _$PostingDetailCopyWithImpl(this._self, this._then);

  final PostingDetail _self;
  final $Res Function(PostingDetail) _then;

/// Create a copy of PostingDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posting = null,Object? events = null,}) {
  return _then(PostingDetail(
posting: null == posting ? _self.posting : posting // ignore: cast_nullable_to_non_nullable
as JobPosting,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<StageEvent>,
  ));
}
/// Create a copy of PostingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobPostingCopyWith<$Res> get posting {
  
  return $JobPostingCopyWith<$Res>(_self.posting, (value) {
    return _then(_self.copyWith(posting: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostingDetail].
extension PostingDetailPatterns on PostingDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostingDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostingDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostingDetail value)  $default,){
final _that = this;
switch (_that) {
case _PostingDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostingDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PostingDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobPosting posting,  List<StageEvent> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostingDetail() when $default != null:
return $default(_that.posting,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobPosting posting,  List<StageEvent> events)  $default,) {final _that = this;
switch (_that) {
case _PostingDetail():
return $default(_that.posting,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobPosting posting,  List<StageEvent> events)?  $default,) {final _that = this;
switch (_that) {
case _PostingDetail() when $default != null:
return $default(_that.posting,_that.events);case _:
  return null;

}
}

}

/// @nodoc


class _PostingDetail implements PostingDetail {
  const _PostingDetail({required this.posting, required  List<StageEvent> events}): _events = events;
  

@override final  JobPosting posting;
 final  List<StageEvent> _events;
@override List<StageEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of PostingDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostingDetailCopyWith<_PostingDetail> get copyWith => __$PostingDetailCopyWithImpl<_PostingDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostingDetail&&(identical(other.posting, posting) || other.posting == posting)&&const DeepCollectionEquality().equals(other.events, _events));
}


@override
int get hashCode {
    return Object.hash(runtimeType,posting,const DeepCollectionEquality().hash(_events));
}

@override
String toString() {
    return 'PostingDetail(posting: $posting, events: $events)';
}


}

/// @nodoc
abstract mixin class _$PostingDetailCopyWith<$Res> implements $PostingDetailCopyWith<$Res> {
  factory _$PostingDetailCopyWith(_PostingDetail value, $Res Function(_PostingDetail) _then) = __$PostingDetailCopyWithImpl;
@override @useResult
$Res call({
 JobPosting posting, List<StageEvent> events
});


@override $JobPostingCopyWith<$Res> get posting;

}
/// @nodoc
class __$PostingDetailCopyWithImpl<$Res>
    implements _$PostingDetailCopyWith<$Res> {
  __$PostingDetailCopyWithImpl(this._self, this._then);

  final _PostingDetail _self;
  final $Res Function(_PostingDetail) _then;

/// Create a copy of PostingDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posting = null,Object? events = null,}) {
  return _then(_PostingDetail(
posting: null == posting ? _self.posting : posting // ignore: cast_nullable_to_non_nullable
as JobPosting,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<StageEvent>,
  ));
}

/// Create a copy of PostingDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobPostingCopyWith<$Res> get posting {
  
  return $JobPostingCopyWith<$Res>(_self.posting, (value) {
    return _then(_self.copyWith(posting: value));
  });
}
}

// dart format on
