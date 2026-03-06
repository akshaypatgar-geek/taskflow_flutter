// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_mutation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskMutationResponse {

 Task get task;
/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskMutationResponseCopyWith<TaskMutationResponse> get copyWith => _$TaskMutationResponseCopyWithImpl<TaskMutationResponse>(this as TaskMutationResponse, _$identity);

  /// Serializes this TaskMutationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskMutationResponse&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskMutationResponse(task: $task)';
}


}

/// @nodoc
abstract mixin class $TaskMutationResponseCopyWith<$Res>  {
  factory $TaskMutationResponseCopyWith(TaskMutationResponse value, $Res Function(TaskMutationResponse) _then) = _$TaskMutationResponseCopyWithImpl;
@useResult
$Res call({
 Task task
});


$TaskCopyWith<$Res> get task;

}
/// @nodoc
class _$TaskMutationResponseCopyWithImpl<$Res>
    implements $TaskMutationResponseCopyWith<$Res> {
  _$TaskMutationResponseCopyWithImpl(this._self, this._then);

  final TaskMutationResponse _self;
  final $Res Function(TaskMutationResponse) _then;

/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,}) {
  return _then(_self.copyWith(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,
  ));
}
/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res> get task {
  
  return $TaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskMutationResponse].
extension TaskMutationResponsePatterns on TaskMutationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskMutationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskMutationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskMutationResponse value)  $default,){
final _that = this;
switch (_that) {
case _TaskMutationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskMutationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TaskMutationResponse() when $default != null:
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
case _TaskMutationResponse() when $default != null:
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
case _TaskMutationResponse():
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
case _TaskMutationResponse() when $default != null:
return $default(_that.task);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskMutationResponse implements TaskMutationResponse {
  const _TaskMutationResponse({required this.task});
  factory _TaskMutationResponse.fromJson(Map<String, dynamic> json) => _$TaskMutationResponseFromJson(json);

@override final  Task task;

/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskMutationResponseCopyWith<_TaskMutationResponse> get copyWith => __$TaskMutationResponseCopyWithImpl<_TaskMutationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskMutationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskMutationResponse&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskMutationResponse(task: $task)';
}


}

/// @nodoc
abstract mixin class _$TaskMutationResponseCopyWith<$Res> implements $TaskMutationResponseCopyWith<$Res> {
  factory _$TaskMutationResponseCopyWith(_TaskMutationResponse value, $Res Function(_TaskMutationResponse) _then) = __$TaskMutationResponseCopyWithImpl;
@override @useResult
$Res call({
 Task task
});


@override $TaskCopyWith<$Res> get task;

}
/// @nodoc
class __$TaskMutationResponseCopyWithImpl<$Res>
    implements _$TaskMutationResponseCopyWith<$Res> {
  __$TaskMutationResponseCopyWithImpl(this._self, this._then);

  final _TaskMutationResponse _self;
  final $Res Function(_TaskMutationResponse) _then;

/// Create a copy of TaskMutationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,}) {
  return _then(_TaskMutationResponse(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,
  ));
}

/// Create a copy of TaskMutationResponse
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
