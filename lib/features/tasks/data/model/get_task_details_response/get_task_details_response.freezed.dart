// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_task_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetTaskDetailsResponse {

 Task get task;
/// Create a copy of GetTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetTaskDetailsResponseCopyWith<GetTaskDetailsResponse> get copyWith => _$GetTaskDetailsResponseCopyWithImpl<GetTaskDetailsResponse>(this as GetTaskDetailsResponse, _$identity);

  /// Serializes this GetTaskDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetTaskDetailsResponse&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'GetTaskDetailsResponse(task: $task)';
}


}

/// @nodoc
abstract mixin class $GetTaskDetailsResponseCopyWith<$Res>  {
  factory $GetTaskDetailsResponseCopyWith(GetTaskDetailsResponse value, $Res Function(GetTaskDetailsResponse) _then) = _$GetTaskDetailsResponseCopyWithImpl;
@useResult
$Res call({
 Task task
});


$TaskCopyWith<$Res> get task;

}
/// @nodoc
class _$GetTaskDetailsResponseCopyWithImpl<$Res>
    implements $GetTaskDetailsResponseCopyWith<$Res> {
  _$GetTaskDetailsResponseCopyWithImpl(this._self, this._then);

  final GetTaskDetailsResponse _self;
  final $Res Function(GetTaskDetailsResponse) _then;

/// Create a copy of GetTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,
  ));
}
/// Create a copy of GetTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res> get task {
  
  return $TaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [GetTaskDetailsResponse].
extension GetTaskDetailsResponsePatterns on GetTaskDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetTaskDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetTaskDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetTaskDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _GetTaskDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetTaskDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GetTaskDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Task task)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetTaskDetailsResponse() when $default != null:
return $default(_that.task);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Task task)  $default,) {final _that = this;
switch (_that) {
case _GetTaskDetailsResponse():
return $default(_that.task);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Task task)?  $default,) {final _that = this;
switch (_that) {
case _GetTaskDetailsResponse() when $default != null:
return $default(_that.task);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetTaskDetailsResponse implements GetTaskDetailsResponse {
  const _GetTaskDetailsResponse({required this.task});
  factory _GetTaskDetailsResponse.fromJson(Map<String, dynamic> json) => _$GetTaskDetailsResponseFromJson(json);

@override final  Task task;

/// Create a copy of GetTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetTaskDetailsResponseCopyWith<_GetTaskDetailsResponse> get copyWith => __$GetTaskDetailsResponseCopyWithImpl<_GetTaskDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetTaskDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetTaskDetailsResponse&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'GetTaskDetailsResponse(task: $task)';
}


}

/// @nodoc
abstract mixin class _$GetTaskDetailsResponseCopyWith<$Res> implements $GetTaskDetailsResponseCopyWith<$Res> {
  factory _$GetTaskDetailsResponseCopyWith(_GetTaskDetailsResponse value, $Res Function(_GetTaskDetailsResponse) _then) = __$GetTaskDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 Task task
});


@override $TaskCopyWith<$Res> get task;

}
/// @nodoc
class __$GetTaskDetailsResponseCopyWithImpl<$Res>
    implements _$GetTaskDetailsResponseCopyWith<$Res> {
  __$GetTaskDetailsResponseCopyWithImpl(this._self, this._then);

  final _GetTaskDetailsResponse _self;
  final $Res Function(_GetTaskDetailsResponse) _then;

/// Create a copy of GetTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,}) {
  return _then(_GetTaskDetailsResponse(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,
  ));
}

/// Create a copy of GetTaskDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res> get task {
  
  return $TaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
