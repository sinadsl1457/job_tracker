// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 LoginMode get mode; bool get submitting; String? get errorMessage;/// 가입은 됐지만 확인 메일을 눌러야 로그인되는 경우(클라우드 기본 설정).
 bool get needsEmailConfirmation;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.needsEmailConfirmation, _this.needsEmailConfirmation) || other.needsEmailConfirmation == _this.needsEmailConfirmation));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,_this.mode,_this.submitting,_this.errorMessage,_this.needsEmailConfirmation);
}

@override
String toString() {
  final _this = this as LoginState;
  return 'LoginState(mode: ${_this.mode}, submitting: ${_this.submitting}, errorMessage: ${_this.errorMessage}, needsEmailConfirmation: ${_this.needsEmailConfirmation})';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 LoginMode mode, bool submitting, String? errorMessage, bool needsEmailConfirmation
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? submitting = null,Object? errorMessage = freezed,Object? needsEmailConfirmation = null,}) {
  return _then(LoginState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as LoginMode,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,needsEmailConfirmation: null == needsEmailConfirmation ? _self.needsEmailConfirmation : needsEmailConfirmation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoginMode mode,  bool submitting,  String? errorMessage,  bool needsEmailConfirmation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.mode,_that.submitting,_that.errorMessage,_that.needsEmailConfirmation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoginMode mode,  bool submitting,  String? errorMessage,  bool needsEmailConfirmation)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.mode,_that.submitting,_that.errorMessage,_that.needsEmailConfirmation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoginMode mode,  bool submitting,  String? errorMessage,  bool needsEmailConfirmation)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.mode,_that.submitting,_that.errorMessage,_that.needsEmailConfirmation);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState implements LoginState {
  const _LoginState({this.mode = LoginMode.signIn, this.submitting = false, this.errorMessage, this.needsEmailConfirmation = false});
  

@override@JsonKey() final  LoginMode mode;
@override@JsonKey() final  bool submitting;
@override final  String? errorMessage;
/// 가입은 됐지만 확인 메일을 눌러야 로그인되는 경우(클라우드 기본 설정).
@override@JsonKey() final  bool needsEmailConfirmation;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.needsEmailConfirmation, needsEmailConfirmation) || other.needsEmailConfirmation == needsEmailConfirmation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,submitting,errorMessage,needsEmailConfirmation);
}

@override
String toString() {
    return 'LoginState(mode: $mode, submitting: $submitting, errorMessage: $errorMessage, needsEmailConfirmation: $needsEmailConfirmation)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 LoginMode mode, bool submitting, String? errorMessage, bool needsEmailConfirmation
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? submitting = null,Object? errorMessage = freezed,Object? needsEmailConfirmation = null,}) {
  return _then(_LoginState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as LoginMode,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,needsEmailConfirmation: null == needsEmailConfirmation ? _self.needsEmailConfirmation : needsEmailConfirmation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
