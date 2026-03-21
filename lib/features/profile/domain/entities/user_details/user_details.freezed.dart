// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserDetails {

 String get userId; String get userEmail; String? get userName; String? get userStatus; String? get profilePicture;
/// Create a copy of UserDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDetailsCopyWith<UserDetails> get copyWith => _$UserDetailsCopyWithImpl<UserDetails>(this as UserDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetails&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userStatus, userStatus) || other.userStatus == userStatus)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}


@override
int get hashCode => Object.hash(runtimeType,userId,userEmail,userName,userStatus,profilePicture);

@override
String toString() {
  return 'UserDetails(userId: $userId, userEmail: $userEmail, userName: $userName, userStatus: $userStatus, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class $UserDetailsCopyWith<$Res>  {
  factory $UserDetailsCopyWith(UserDetails value, $Res Function(UserDetails) _then) = _$UserDetailsCopyWithImpl;
@useResult
$Res call({
 String userId, String userEmail, String? userName, String? userStatus, String? profilePicture
});




}
/// @nodoc
class _$UserDetailsCopyWithImpl<$Res>
    implements $UserDetailsCopyWith<$Res> {
  _$UserDetailsCopyWithImpl(this._self, this._then);

  final UserDetails _self;
  final $Res Function(UserDetails) _then;

/// Create a copy of UserDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? userEmail = null,Object? userName = freezed,Object? userStatus = freezed,Object? profilePicture = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userStatus: freezed == userStatus ? _self.userStatus : userStatus // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDetails].
extension UserDetailsPatterns on UserDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDetails value)  $default,){
final _that = this;
switch (_that) {
case _UserDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDetails value)?  $default,){
final _that = this;
switch (_that) {
case _UserDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String userEmail,  String? userName,  String? userStatus,  String? profilePicture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDetails() when $default != null:
return $default(_that.userId,_that.userEmail,_that.userName,_that.userStatus,_that.profilePicture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String userEmail,  String? userName,  String? userStatus,  String? profilePicture)  $default,) {final _that = this;
switch (_that) {
case _UserDetails():
return $default(_that.userId,_that.userEmail,_that.userName,_that.userStatus,_that.profilePicture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String userEmail,  String? userName,  String? userStatus,  String? profilePicture)?  $default,) {final _that = this;
switch (_that) {
case _UserDetails() when $default != null:
return $default(_that.userId,_that.userEmail,_that.userName,_that.userStatus,_that.profilePicture);case _:
  return null;

}
}

}

/// @nodoc


class _UserDetails implements UserDetails {
  const _UserDetails({required this.userId, required this.userEmail, this.userName, this.userStatus, this.profilePicture});
  

@override final  String userId;
@override final  String userEmail;
@override final  String? userName;
@override final  String? userStatus;
@override final  String? profilePicture;

/// Create a copy of UserDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDetailsCopyWith<_UserDetails> get copyWith => __$UserDetailsCopyWithImpl<_UserDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetails&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userStatus, userStatus) || other.userStatus == userStatus)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}


@override
int get hashCode => Object.hash(runtimeType,userId,userEmail,userName,userStatus,profilePicture);

@override
String toString() {
  return 'UserDetails(userId: $userId, userEmail: $userEmail, userName: $userName, userStatus: $userStatus, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class _$UserDetailsCopyWith<$Res> implements $UserDetailsCopyWith<$Res> {
  factory _$UserDetailsCopyWith(_UserDetails value, $Res Function(_UserDetails) _then) = __$UserDetailsCopyWithImpl;
@override @useResult
$Res call({
 String userId, String userEmail, String? userName, String? userStatus, String? profilePicture
});




}
/// @nodoc
class __$UserDetailsCopyWithImpl<$Res>
    implements _$UserDetailsCopyWith<$Res> {
  __$UserDetailsCopyWithImpl(this._self, this._then);

  final _UserDetails _self;
  final $Res Function(_UserDetails) _then;

/// Create a copy of UserDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? userEmail = null,Object? userName = freezed,Object? userStatus = freezed,Object? profilePicture = freezed,}) {
  return _then(_UserDetails(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userStatus: freezed == userStatus ? _self.userStatus : userStatus // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
