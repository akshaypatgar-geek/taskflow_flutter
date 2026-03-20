// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDetailsModel {

@JsonKey(name: 'id') String get userId;@JsonKey(name: 'name') String? get userName;@JsonKey(name: 'email') String get userEmail;@JsonKey(name: 'status') String? get userStatus; String? get profilePicture;
/// Create a copy of UserDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDetailsModelCopyWith<UserDetailsModel> get copyWith => _$UserDetailsModelCopyWithImpl<UserDetailsModel>(this as UserDetailsModel, _$identity);

  /// Serializes this UserDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetailsModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userStatus, userStatus) || other.userStatus == userStatus)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,userName,userEmail,userStatus,profilePicture);

@override
String toString() {
  return 'UserDetailsModel(userId: $userId, userName: $userName, userEmail: $userEmail, userStatus: $userStatus, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class $UserDetailsModelCopyWith<$Res>  {
  factory $UserDetailsModelCopyWith(UserDetailsModel value, $Res Function(UserDetailsModel) _then) = _$UserDetailsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String userId,@JsonKey(name: 'name') String? userName,@JsonKey(name: 'email') String userEmail,@JsonKey(name: 'status') String? userStatus, String? profilePicture
});




}
/// @nodoc
class _$UserDetailsModelCopyWithImpl<$Res>
    implements $UserDetailsModelCopyWith<$Res> {
  _$UserDetailsModelCopyWithImpl(this._self, this._then);

  final UserDetailsModel _self;
  final $Res Function(UserDetailsModel) _then;

/// Create a copy of UserDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? userName = freezed,Object? userEmail = null,Object? userStatus = freezed,Object? profilePicture = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,userStatus: freezed == userStatus ? _self.userStatus : userStatus // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDetailsModel].
extension UserDetailsModelPatterns on UserDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _UserDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId, @JsonKey(name: 'name')  String? userName, @JsonKey(name: 'email')  String userEmail, @JsonKey(name: 'status')  String? userStatus,  String? profilePicture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDetailsModel() when $default != null:
return $default(_that.userId,_that.userName,_that.userEmail,_that.userStatus,_that.profilePicture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String userId, @JsonKey(name: 'name')  String? userName, @JsonKey(name: 'email')  String userEmail, @JsonKey(name: 'status')  String? userStatus,  String? profilePicture)  $default,) {final _that = this;
switch (_that) {
case _UserDetailsModel():
return $default(_that.userId,_that.userName,_that.userEmail,_that.userStatus,_that.profilePicture);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String userId, @JsonKey(name: 'name')  String? userName, @JsonKey(name: 'email')  String userEmail, @JsonKey(name: 'status')  String? userStatus,  String? profilePicture)?  $default,) {final _that = this;
switch (_that) {
case _UserDetailsModel() when $default != null:
return $default(_that.userId,_that.userName,_that.userEmail,_that.userStatus,_that.profilePicture);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDetailsModel implements UserDetailsModel {
  const _UserDetailsModel({@JsonKey(name: 'id') required this.userId, @JsonKey(name: 'name') this.userName, @JsonKey(name: 'email') required this.userEmail, @JsonKey(name: 'status') this.userStatus, this.profilePicture});
  factory _UserDetailsModel.fromJson(Map<String, dynamic> json) => _$UserDetailsModelFromJson(json);

@override@JsonKey(name: 'id') final  String userId;
@override@JsonKey(name: 'name') final  String? userName;
@override@JsonKey(name: 'email') final  String userEmail;
@override@JsonKey(name: 'status') final  String? userStatus;
@override final  String? profilePicture;

/// Create a copy of UserDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDetailsModelCopyWith<_UserDetailsModel> get copyWith => __$UserDetailsModelCopyWithImpl<_UserDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetailsModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.userStatus, userStatus) || other.userStatus == userStatus)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,userName,userEmail,userStatus,profilePicture);

@override
String toString() {
  return 'UserDetailsModel(userId: $userId, userName: $userName, userEmail: $userEmail, userStatus: $userStatus, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class _$UserDetailsModelCopyWith<$Res> implements $UserDetailsModelCopyWith<$Res> {
  factory _$UserDetailsModelCopyWith(_UserDetailsModel value, $Res Function(_UserDetailsModel) _then) = __$UserDetailsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String userId,@JsonKey(name: 'name') String? userName,@JsonKey(name: 'email') String userEmail,@JsonKey(name: 'status') String? userStatus, String? profilePicture
});




}
/// @nodoc
class __$UserDetailsModelCopyWithImpl<$Res>
    implements _$UserDetailsModelCopyWith<$Res> {
  __$UserDetailsModelCopyWithImpl(this._self, this._then);

  final _UserDetailsModel _self;
  final $Res Function(_UserDetailsModel) _then;

/// Create a copy of UserDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? userName = freezed,Object? userEmail = null,Object? userStatus = freezed,Object? profilePicture = freezed,}) {
  return _then(_UserDetailsModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,userStatus: freezed == userStatus ? _self.userStatus : userStatus // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
