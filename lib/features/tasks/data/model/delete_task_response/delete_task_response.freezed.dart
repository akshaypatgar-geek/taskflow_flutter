// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_task_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteTaskResponse {

@JsonKey(name: 'id') String get taskId;
/// Create a copy of DeleteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteTaskResponseCopyWith<DeleteTaskResponse> get copyWith => _$DeleteTaskResponseCopyWithImpl<DeleteTaskResponse>(this as DeleteTaskResponse, _$identity);

  /// Serializes this DeleteTaskResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId);

@override
String toString() {
  return 'DeleteTaskResponse(taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class $DeleteTaskResponseCopyWith<$Res>  {
  factory $DeleteTaskResponseCopyWith(DeleteTaskResponse value, $Res Function(DeleteTaskResponse) _then) = _$DeleteTaskResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String taskId
});




}
/// @nodoc
class _$DeleteTaskResponseCopyWithImpl<$Res>
    implements $DeleteTaskResponseCopyWith<$Res> {
  _$DeleteTaskResponseCopyWithImpl(this._self, this._then);

  final DeleteTaskResponse _self;
  final $Res Function(DeleteTaskResponse) _then;

/// Create a copy of DeleteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteTaskResponse].
extension DeleteTaskResponsePatterns on DeleteTaskResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteTaskResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteTaskResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteTaskResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeleteTaskResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteTaskResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteTaskResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String taskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeleteTaskResponse() when $default != null:
return $default(_that.taskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String taskId)  $default,) {final _that = this;
switch (_that) {
case _DeleteTaskResponse():
return $default(_that.taskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String taskId)?  $default,) {final _that = this;
switch (_that) {
case _DeleteTaskResponse() when $default != null:
return $default(_that.taskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteTaskResponse implements DeleteTaskResponse {
  const _DeleteTaskResponse({@JsonKey(name: 'id') required this.taskId});
  factory _DeleteTaskResponse.fromJson(Map<String, dynamic> json) => _$DeleteTaskResponseFromJson(json);

@override@JsonKey(name: 'id') final  String taskId;

/// Create a copy of DeleteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteTaskResponseCopyWith<_DeleteTaskResponse> get copyWith => __$DeleteTaskResponseCopyWithImpl<_DeleteTaskResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteTaskResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteTaskResponse&&(identical(other.taskId, taskId) || other.taskId == taskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId);

@override
String toString() {
  return 'DeleteTaskResponse(taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class _$DeleteTaskResponseCopyWith<$Res> implements $DeleteTaskResponseCopyWith<$Res> {
  factory _$DeleteTaskResponseCopyWith(_DeleteTaskResponse value, $Res Function(_DeleteTaskResponse) _then) = __$DeleteTaskResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String taskId
});




}
/// @nodoc
class __$DeleteTaskResponseCopyWithImpl<$Res>
    implements _$DeleteTaskResponseCopyWith<$Res> {
  __$DeleteTaskResponseCopyWithImpl(this._self, this._then);

  final _DeleteTaskResponse _self;
  final $Res Function(_DeleteTaskResponse) _then;

/// Create a copy of DeleteTaskResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,}) {
  return _then(_DeleteTaskResponse(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
