// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateUserResponse {

@JsonKey(name: "id") String get userId;@JsonKey(name: "email") String get userEmail;
/// Create a copy of CreateUserResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateUserResponseCopyWith<CreateUserResponse> get copyWith => _$CreateUserResponseCopyWithImpl<CreateUserResponse>(this as CreateUserResponse, _$identity);

  /// Serializes this CreateUserResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,userEmail);

@override
String toString() {
  return 'CreateUserResponse(userId: $userId, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class $CreateUserResponseCopyWith<$Res>  {
  factory $CreateUserResponseCopyWith(CreateUserResponse value, $Res Function(CreateUserResponse) _then) = _$CreateUserResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String userId,@JsonKey(name: "email") String userEmail
});




}
/// @nodoc
class _$CreateUserResponseCopyWithImpl<$Res>
    implements $CreateUserResponseCopyWith<$Res> {
  _$CreateUserResponseCopyWithImpl(this._self, this._then);

  final CreateUserResponse _self;
  final $Res Function(CreateUserResponse) _then;

/// Create a copy of CreateUserResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? userEmail = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateUserResponse].
extension CreateUserResponsePatterns on CreateUserResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateUserResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateUserResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateUserResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreateUserResponse():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateUserResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreateUserResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String userId, @JsonKey(name: "email")  String userEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateUserResponse() when $default != null:
return $default(_that.userId,_that.userEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String userId, @JsonKey(name: "email")  String userEmail)  $default,) {final _that = this;
switch (_that) {
case _CreateUserResponse():
return $default(_that.userId,_that.userEmail);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String userId, @JsonKey(name: "email")  String userEmail)?  $default,) {final _that = this;
switch (_that) {
case _CreateUserResponse() when $default != null:
return $default(_that.userId,_that.userEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateUserResponse implements CreateUserResponse {
  const _CreateUserResponse({@JsonKey(name: "id") required this.userId, @JsonKey(name: "email") required this.userEmail});
  factory _CreateUserResponse.fromJson(Map<String, dynamic> json) => _$CreateUserResponseFromJson(json);

@override@JsonKey(name: "id") final  String userId;
@override@JsonKey(name: "email") final  String userEmail;

/// Create a copy of CreateUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateUserResponseCopyWith<_CreateUserResponse> get copyWith => __$CreateUserResponseCopyWithImpl<_CreateUserResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateUserResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateUserResponse&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,userEmail);

@override
String toString() {
  return 'CreateUserResponse(userId: $userId, userEmail: $userEmail)';
}


}

/// @nodoc
abstract mixin class _$CreateUserResponseCopyWith<$Res> implements $CreateUserResponseCopyWith<$Res> {
  factory _$CreateUserResponseCopyWith(_CreateUserResponse value, $Res Function(_CreateUserResponse) _then) = __$CreateUserResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String userId,@JsonKey(name: "email") String userEmail
});




}
/// @nodoc
class __$CreateUserResponseCopyWithImpl<$Res>
    implements _$CreateUserResponseCopyWith<$Res> {
  __$CreateUserResponseCopyWithImpl(this._self, this._then);

  final _CreateUserResponse _self;
  final $Res Function(_CreateUserResponse) _then;

/// Create a copy of CreateUserResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? userEmail = null,}) {
  return _then(_CreateUserResponse(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
