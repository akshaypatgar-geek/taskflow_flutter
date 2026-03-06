// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_tasks_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListTasksResponse {

 List<Task> get tasks; String? get nextCursor; bool get hasNextPage;
/// Create a copy of ListTasksResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListTasksResponseCopyWith<ListTasksResponse> get copyWith => _$ListTasksResponseCopyWithImpl<ListTasksResponse>(this as ListTasksResponse, _$identity);

  /// Serializes this ListTasksResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListTasksResponse&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tasks),nextCursor,hasNextPage);

@override
String toString() {
  return 'ListTasksResponse(tasks: $tasks, nextCursor: $nextCursor, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class $ListTasksResponseCopyWith<$Res>  {
  factory $ListTasksResponseCopyWith(ListTasksResponse value, $Res Function(ListTasksResponse) _then) = _$ListTasksResponseCopyWithImpl;
@useResult
$Res call({
 List<Task> tasks, String? nextCursor, bool hasNextPage
});




}
/// @nodoc
class _$ListTasksResponseCopyWithImpl<$Res>
    implements $ListTasksResponseCopyWith<$Res> {
  _$ListTasksResponseCopyWithImpl(this._self, this._then);

  final ListTasksResponse _self;
  final $Res Function(ListTasksResponse) _then;

/// Create a copy of ListTasksResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tasks = null,Object? nextCursor = freezed,Object? hasNextPage = null,}) {
  return _then(_self.copyWith(
tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ListTasksResponse].
extension ListTasksResponsePatterns on ListTasksResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListTasksResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListTasksResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListTasksResponse value)  $default,){
final _that = this;
switch (_that) {
case _ListTasksResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListTasksResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ListTasksResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Task> tasks,  String? nextCursor,  bool hasNextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListTasksResponse() when $default != null:
return $default(_that.tasks,_that.nextCursor,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Task> tasks,  String? nextCursor,  bool hasNextPage)  $default,) {final _that = this;
switch (_that) {
case _ListTasksResponse():
return $default(_that.tasks,_that.nextCursor,_that.hasNextPage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Task> tasks,  String? nextCursor,  bool hasNextPage)?  $default,) {final _that = this;
switch (_that) {
case _ListTasksResponse() when $default != null:
return $default(_that.tasks,_that.nextCursor,_that.hasNextPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListTasksResponse implements ListTasksResponse {
  const _ListTasksResponse({required final  List<Task> tasks, this.nextCursor, required this.hasNextPage}): _tasks = tasks;
  factory _ListTasksResponse.fromJson(Map<String, dynamic> json) => _$ListTasksResponseFromJson(json);

 final  List<Task> _tasks;
@override List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override final  String? nextCursor;
@override final  bool hasNextPage;

/// Create a copy of ListTasksResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListTasksResponseCopyWith<_ListTasksResponse> get copyWith => __$ListTasksResponseCopyWithImpl<_ListTasksResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListTasksResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListTasksResponse&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks),nextCursor,hasNextPage);

@override
String toString() {
  return 'ListTasksResponse(tasks: $tasks, nextCursor: $nextCursor, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class _$ListTasksResponseCopyWith<$Res> implements $ListTasksResponseCopyWith<$Res> {
  factory _$ListTasksResponseCopyWith(_ListTasksResponse value, $Res Function(_ListTasksResponse) _then) = __$ListTasksResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Task> tasks, String? nextCursor, bool hasNextPage
});




}
/// @nodoc
class __$ListTasksResponseCopyWithImpl<$Res>
    implements _$ListTasksResponseCopyWith<$Res> {
  __$ListTasksResponseCopyWithImpl(this._self, this._then);

  final _ListTasksResponse _self;
  final $Res Function(_ListTasksResponse) _then;

/// Create a copy of ListTasksResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? nextCursor = freezed,Object? hasNextPage = null,}) {
  return _then(_ListTasksResponse(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
