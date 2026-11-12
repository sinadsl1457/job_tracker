// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_posting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobPosting {

 String get id; String get company; String get position; String? get url; JobChannel get channel;@DateOnlyConverter() DateTime? get deadline; String? get location; EmploymentType? get employmentType; String? get memo; ApplicationStage get stage; DateTime get stageChangedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPostingCopyWith<JobPosting> get copyWith => _$JobPostingCopyWithImpl<JobPosting>(this as JobPosting, _$identity);

  /// Serializes this JobPosting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JobPosting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPosting&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.company, _this.company) || other.company == _this.company)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.employmentType, _this.employmentType) || other.employmentType == _this.employmentType)&&(identical(other.memo, _this.memo) || other.memo == _this.memo)&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.stageChangedAt, _this.stageChangedAt) || other.stageChangedAt == _this.stageChangedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JobPosting;
  return Object.hash(runtimeType,_this.id,_this.company,_this.position,_this.url,_this.channel,_this.deadline,_this.location,_this.employmentType,_this.memo,_this.stage,_this.stageChangedAt,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as JobPosting;
  return 'JobPosting(id: ${_this.id}, company: ${_this.company}, position: ${_this.position}, url: ${_this.url}, channel: ${_this.channel}, deadline: ${_this.deadline}, location: ${_this.location}, employmentType: ${_this.employmentType}, memo: ${_this.memo}, stage: ${_this.stage}, stageChangedAt: ${_this.stageChangedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $JobPostingCopyWith<$Res>  {
  factory $JobPostingCopyWith(JobPosting value, $Res Function(JobPosting) _then) = _$JobPostingCopyWithImpl;
@useResult
$Res call({
 String id, String company, String position, String? url, JobChannel channel,@DateOnlyConverter() DateTime? deadline, String? location, EmploymentType? employmentType, String? memo, ApplicationStage stage, DateTime stageChangedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$JobPostingCopyWithImpl<$Res>
    implements $JobPostingCopyWith<$Res> {
  _$JobPostingCopyWithImpl(this._self, this._then);

  final JobPosting _self;
  final $Res Function(JobPosting) _then;

/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? company = null,Object? position = null,Object? url = freezed,Object? channel = null,Object? deadline = freezed,Object? location = freezed,Object? employmentType = freezed,Object? memo = freezed,Object? stage = null,Object? stageChangedAt = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(JobPosting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as JobChannel,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as EmploymentType?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ApplicationStage,stageChangedAt: null == stageChangedAt ? _self.stageChangedAt : stageChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JobPosting].
extension JobPostingPatterns on JobPosting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobPosting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobPosting value)  $default,){
final _that = this;
switch (_that) {
case _JobPosting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobPosting value)?  $default,){
final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String company,  String position,  String? url,  JobChannel channel, @DateOnlyConverter()  DateTime? deadline,  String? location,  EmploymentType? employmentType,  String? memo,  ApplicationStage stage,  DateTime stageChangedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
return $default(_that.id,_that.company,_that.position,_that.url,_that.channel,_that.deadline,_that.location,_that.employmentType,_that.memo,_that.stage,_that.stageChangedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String company,  String position,  String? url,  JobChannel channel, @DateOnlyConverter()  DateTime? deadline,  String? location,  EmploymentType? employmentType,  String? memo,  ApplicationStage stage,  DateTime stageChangedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JobPosting():
return $default(_that.id,_that.company,_that.position,_that.url,_that.channel,_that.deadline,_that.location,_that.employmentType,_that.memo,_that.stage,_that.stageChangedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String company,  String position,  String? url,  JobChannel channel, @DateOnlyConverter()  DateTime? deadline,  String? location,  EmploymentType? employmentType,  String? memo,  ApplicationStage stage,  DateTime stageChangedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobPosting() when $default != null:
return $default(_that.id,_that.company,_that.position,_that.url,_that.channel,_that.deadline,_that.location,_that.employmentType,_that.memo,_that.stage,_that.stageChangedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobPosting implements JobPosting {
  const _JobPosting({required this.id, required this.company, required this.position, this.url, required this.channel, @DateOnlyConverter() this.deadline, this.location, this.employmentType, this.memo, required this.stage, required this.stageChangedAt, required this.createdAt, required this.updatedAt});
  factory _JobPosting.fromJson(Map<String, dynamic> json) => _$JobPostingFromJson(json);

@override final  String id;
@override final  String company;
@override final  String position;
@override final  String? url;
@override final  JobChannel channel;
@override@DateOnlyConverter() final  DateTime? deadline;
@override final  String? location;
@override final  EmploymentType? employmentType;
@override final  String? memo;
@override final  ApplicationStage stage;
@override final  DateTime stageChangedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobPostingCopyWith<_JobPosting> get copyWith => __$JobPostingCopyWithImpl<_JobPosting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobPostingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPosting&&(identical(other.id, id) || other.id == id)&&(identical(other.company, company) || other.company == company)&&(identical(other.position, position) || other.position == position)&&(identical(other.url, url) || other.url == url)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.location, location) || other.location == location)&&(identical(other.employmentType, employmentType) || other.employmentType == employmentType)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.stageChangedAt, stageChangedAt) || other.stageChangedAt == stageChangedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,company,position,url,channel,deadline,location,employmentType,memo,stage,stageChangedAt,createdAt,updatedAt);
}

@override
String toString() {
    return 'JobPosting(id: $id, company: $company, position: $position, url: $url, channel: $channel, deadline: $deadline, location: $location, employmentType: $employmentType, memo: $memo, stage: $stage, stageChangedAt: $stageChangedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobPostingCopyWith<$Res> implements $JobPostingCopyWith<$Res> {
  factory _$JobPostingCopyWith(_JobPosting value, $Res Function(_JobPosting) _then) = __$JobPostingCopyWithImpl;
@override @useResult
$Res call({
 String id, String company, String position, String? url, JobChannel channel,@DateOnlyConverter() DateTime? deadline, String? location, EmploymentType? employmentType, String? memo, ApplicationStage stage, DateTime stageChangedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$JobPostingCopyWithImpl<$Res>
    implements _$JobPostingCopyWith<$Res> {
  __$JobPostingCopyWithImpl(this._self, this._then);

  final _JobPosting _self;
  final $Res Function(_JobPosting) _then;

/// Create a copy of JobPosting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? company = null,Object? position = null,Object? url = freezed,Object? channel = null,Object? deadline = freezed,Object? location = freezed,Object? employmentType = freezed,Object? memo = freezed,Object? stage = null,Object? stageChangedAt = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_JobPosting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as JobChannel,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as EmploymentType?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ApplicationStage,stageChangedAt: null == stageChangedAt ? _self.stageChangedAt : stageChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$PostingDraft {

 String get company; String get position; String? get url; JobChannel get channel; DateTime? get deadline; String? get location; EmploymentType? get employmentType; String? get memo;
/// Create a copy of PostingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostingDraftCopyWith<PostingDraft> get copyWith => _$PostingDraftCopyWithImpl<PostingDraft>(this as PostingDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PostingDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostingDraft&&(identical(other.company, _this.company) || other.company == _this.company)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.employmentType, _this.employmentType) || other.employmentType == _this.employmentType)&&(identical(other.memo, _this.memo) || other.memo == _this.memo));
}


@override
int get hashCode {
  final _this = this as PostingDraft;
  return Object.hash(runtimeType,_this.company,_this.position,_this.url,_this.channel,_this.deadline,_this.location,_this.employmentType,_this.memo);
}

@override
String toString() {
  final _this = this as PostingDraft;
  return 'PostingDraft(company: ${_this.company}, position: ${_this.position}, url: ${_this.url}, channel: ${_this.channel}, deadline: ${_this.deadline}, location: ${_this.location}, employmentType: ${_this.employmentType}, memo: ${_this.memo})';
}


}

/// @nodoc
abstract mixin class $PostingDraftCopyWith<$Res>  {
  factory $PostingDraftCopyWith(PostingDraft value, $Res Function(PostingDraft) _then) = _$PostingDraftCopyWithImpl;
@useResult
$Res call({
 String company, String position, String? url, JobChannel channel, DateTime? deadline, String? location, EmploymentType? employmentType, String? memo
});




}
/// @nodoc
class _$PostingDraftCopyWithImpl<$Res>
    implements $PostingDraftCopyWith<$Res> {
  _$PostingDraftCopyWithImpl(this._self, this._then);

  final PostingDraft _self;
  final $Res Function(PostingDraft) _then;

/// Create a copy of PostingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? company = null,Object? position = null,Object? url = freezed,Object? channel = null,Object? deadline = freezed,Object? location = freezed,Object? employmentType = freezed,Object? memo = freezed,}) {
  return _then(PostingDraft(
company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as JobChannel,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as EmploymentType?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostingDraft].
extension PostingDraftPatterns on PostingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostingDraft value)  $default,){
final _that = this;
switch (_that) {
case _PostingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PostingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String company,  String position,  String? url,  JobChannel channel,  DateTime? deadline,  String? location,  EmploymentType? employmentType,  String? memo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostingDraft() when $default != null:
return $default(_that.company,_that.position,_that.url,_that.channel,_that.deadline,_that.location,_that.employmentType,_that.memo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String company,  String position,  String? url,  JobChannel channel,  DateTime? deadline,  String? location,  EmploymentType? employmentType,  String? memo)  $default,) {final _that = this;
switch (_that) {
case _PostingDraft():
return $default(_that.company,_that.position,_that.url,_that.channel,_that.deadline,_that.location,_that.employmentType,_that.memo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String company,  String position,  String? url,  JobChannel channel,  DateTime? deadline,  String? location,  EmploymentType? employmentType,  String? memo)?  $default,) {final _that = this;
switch (_that) {
case _PostingDraft() when $default != null:
return $default(_that.company,_that.position,_that.url,_that.channel,_that.deadline,_that.location,_that.employmentType,_that.memo);case _:
  return null;

}
}

}

/// @nodoc


class _PostingDraft extends PostingDraft {
  const _PostingDraft({this.company = '', this.position = '', this.url, this.channel = JobChannel.other, this.deadline, this.location, this.employmentType, this.memo}): super._();
  

@override@JsonKey() final  String company;
@override@JsonKey() final  String position;
@override final  String? url;
@override@JsonKey() final  JobChannel channel;
@override final  DateTime? deadline;
@override final  String? location;
@override final  EmploymentType? employmentType;
@override final  String? memo;

/// Create a copy of PostingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostingDraftCopyWith<_PostingDraft> get copyWith => __$PostingDraftCopyWithImpl<_PostingDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostingDraft&&(identical(other.company, company) || other.company == company)&&(identical(other.position, position) || other.position == position)&&(identical(other.url, url) || other.url == url)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.location, location) || other.location == location)&&(identical(other.employmentType, employmentType) || other.employmentType == employmentType)&&(identical(other.memo, memo) || other.memo == memo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,company,position,url,channel,deadline,location,employmentType,memo);
}

@override
String toString() {
    return 'PostingDraft(company: $company, position: $position, url: $url, channel: $channel, deadline: $deadline, location: $location, employmentType: $employmentType, memo: $memo)';
}


}

/// @nodoc
abstract mixin class _$PostingDraftCopyWith<$Res> implements $PostingDraftCopyWith<$Res> {
  factory _$PostingDraftCopyWith(_PostingDraft value, $Res Function(_PostingDraft) _then) = __$PostingDraftCopyWithImpl;
@override @useResult
$Res call({
 String company, String position, String? url, JobChannel channel, DateTime? deadline, String? location, EmploymentType? employmentType, String? memo
});




}
/// @nodoc
class __$PostingDraftCopyWithImpl<$Res>
    implements _$PostingDraftCopyWith<$Res> {
  __$PostingDraftCopyWithImpl(this._self, this._then);

  final _PostingDraft _self;
  final $Res Function(_PostingDraft) _then;

/// Create a copy of PostingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? company = null,Object? position = null,Object? url = freezed,Object? channel = null,Object? deadline = freezed,Object? location = freezed,Object? employmentType = freezed,Object? memo = freezed,}) {
  return _then(_PostingDraft(
company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as JobChannel,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,employmentType: freezed == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as EmploymentType?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StageEvent {

 int get id; String get postingId; ApplicationStage? get fromStage; ApplicationStage get toStage; DateTime get changedAt;
/// Create a copy of StageEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StageEventCopyWith<StageEvent> get copyWith => _$StageEventCopyWithImpl<StageEvent>(this as StageEvent, _$identity);

  /// Serializes this StageEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StageEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StageEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.postingId, _this.postingId) || other.postingId == _this.postingId)&&(identical(other.fromStage, _this.fromStage) || other.fromStage == _this.fromStage)&&(identical(other.toStage, _this.toStage) || other.toStage == _this.toStage)&&(identical(other.changedAt, _this.changedAt) || other.changedAt == _this.changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StageEvent;
  return Object.hash(runtimeType,_this.id,_this.postingId,_this.fromStage,_this.toStage,_this.changedAt);
}

@override
String toString() {
  final _this = this as StageEvent;
  return 'StageEvent(id: ${_this.id}, postingId: ${_this.postingId}, fromStage: ${_this.fromStage}, toStage: ${_this.toStage}, changedAt: ${_this.changedAt})';
}


}

/// @nodoc
abstract mixin class $StageEventCopyWith<$Res>  {
  factory $StageEventCopyWith(StageEvent value, $Res Function(StageEvent) _then) = _$StageEventCopyWithImpl;
@useResult
$Res call({
 int id, String postingId, ApplicationStage? fromStage, ApplicationStage toStage, DateTime changedAt
});




}
/// @nodoc
class _$StageEventCopyWithImpl<$Res>
    implements $StageEventCopyWith<$Res> {
  _$StageEventCopyWithImpl(this._self, this._then);

  final StageEvent _self;
  final $Res Function(StageEvent) _then;

/// Create a copy of StageEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postingId = null,Object? fromStage = freezed,Object? toStage = null,Object? changedAt = null,}) {
  return _then(StageEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,postingId: null == postingId ? _self.postingId : postingId // ignore: cast_nullable_to_non_nullable
as String,fromStage: freezed == fromStage ? _self.fromStage : fromStage // ignore: cast_nullable_to_non_nullable
as ApplicationStage?,toStage: null == toStage ? _self.toStage : toStage // ignore: cast_nullable_to_non_nullable
as ApplicationStage,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StageEvent].
extension StageEventPatterns on StageEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StageEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StageEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StageEvent value)  $default,){
final _that = this;
switch (_that) {
case _StageEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StageEvent value)?  $default,){
final _that = this;
switch (_that) {
case _StageEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String postingId,  ApplicationStage? fromStage,  ApplicationStage toStage,  DateTime changedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StageEvent() when $default != null:
return $default(_that.id,_that.postingId,_that.fromStage,_that.toStage,_that.changedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String postingId,  ApplicationStage? fromStage,  ApplicationStage toStage,  DateTime changedAt)  $default,) {final _that = this;
switch (_that) {
case _StageEvent():
return $default(_that.id,_that.postingId,_that.fromStage,_that.toStage,_that.changedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String postingId,  ApplicationStage? fromStage,  ApplicationStage toStage,  DateTime changedAt)?  $default,) {final _that = this;
switch (_that) {
case _StageEvent() when $default != null:
return $default(_that.id,_that.postingId,_that.fromStage,_that.toStage,_that.changedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StageEvent implements StageEvent {
  const _StageEvent({required this.id, required this.postingId, this.fromStage, required this.toStage, required this.changedAt});
  factory _StageEvent.fromJson(Map<String, dynamic> json) => _$StageEventFromJson(json);

@override final  int id;
@override final  String postingId;
@override final  ApplicationStage? fromStage;
@override final  ApplicationStage toStage;
@override final  DateTime changedAt;

/// Create a copy of StageEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StageEventCopyWith<_StageEvent> get copyWith => __$StageEventCopyWithImpl<_StageEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StageEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StageEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.postingId, postingId) || other.postingId == postingId)&&(identical(other.fromStage, fromStage) || other.fromStage == fromStage)&&(identical(other.toStage, toStage) || other.toStage == toStage)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,postingId,fromStage,toStage,changedAt);
}

@override
String toString() {
    return 'StageEvent(id: $id, postingId: $postingId, fromStage: $fromStage, toStage: $toStage, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class _$StageEventCopyWith<$Res> implements $StageEventCopyWith<$Res> {
  factory _$StageEventCopyWith(_StageEvent value, $Res Function(_StageEvent) _then) = __$StageEventCopyWithImpl;
@override @useResult
$Res call({
 int id, String postingId, ApplicationStage? fromStage, ApplicationStage toStage, DateTime changedAt
});




}
/// @nodoc
class __$StageEventCopyWithImpl<$Res>
    implements _$StageEventCopyWith<$Res> {
  __$StageEventCopyWithImpl(this._self, this._then);

  final _StageEvent _self;
  final $Res Function(_StageEvent) _then;

/// Create a copy of StageEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postingId = null,Object? fromStage = freezed,Object? toStage = null,Object? changedAt = null,}) {
  return _then(_StageEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,postingId: null == postingId ? _self.postingId : postingId // ignore: cast_nullable_to_non_nullable
as String,fromStage: freezed == fromStage ? _self.fromStage : fromStage // ignore: cast_nullable_to_non_nullable
as ApplicationStage?,toStage: null == toStage ? _self.toStage : toStage // ignore: cast_nullable_to_non_nullable
as ApplicationStage,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
