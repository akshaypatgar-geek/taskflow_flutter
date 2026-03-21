// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exception_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExceptionResponse implements DiagnosticableTreeMixin {

 int get statusCode;@JsonKey(name: "Message") String get errorMessage;
/// Create a copy of ExceptionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExceptionResponseCopyWith<ExceptionResponse> get copyWith => _$ExceptionResponseCopyWithImpl<ExceptionResponse>(this as ExceptionResponse, _$identity);

  /// Serializes this ExceptionResponse to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExceptionResponse'))
    ..add(DiagnosticsProperty('statusCode', statusCode))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExceptionResponse&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExceptionResponse(statusCode: $statusCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ExceptionResponseCopyWith<$Res>  {
  factory $ExceptionResponseCopyWith(ExceptionResponse value, $Res Function(ExceptionResponse) _then) = _$ExceptionResponseCopyWithImpl;
@useResult
$Res call({
 int statusCode,@JsonKey(name: "Message") String errorMessage
});




}
/// @nodoc
class _$ExceptionResponseCopyWithImpl<$Res>
    implements $ExceptionResponseCopyWith<$Res> {
  _$ExceptionResponseCopyWithImpl(this._self, this._then);

  final ExceptionResponse _self;
  final $Res Function(ExceptionResponse) _then;

/// Create a copy of ExceptionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusCode = null,Object? errorMessage = null,}) {
  return _then(_self.copyWith(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExceptionResponse].
extension ExceptionResponsePatterns on ExceptionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExceptionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExceptionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExceptionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ExceptionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExceptionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ExceptionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int statusCode, @JsonKey(name: "Message")  String errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExceptionResponse() when $default != null:
return $default(_that.statusCode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int statusCode, @JsonKey(name: "Message")  String errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ExceptionResponse():
return $default(_that.statusCode,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int statusCode, @JsonKey(name: "Message")  String errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ExceptionResponse() when $default != null:
return $default(_that.statusCode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExceptionResponse with DiagnosticableTreeMixin implements ExceptionResponse {
  const _ExceptionResponse({required this.statusCode, @JsonKey(name: "Message") required this.errorMessage});
  factory _ExceptionResponse.fromJson(Map<String, dynamic> json) => _$ExceptionResponseFromJson(json);

@override final  int statusCode;
@override@JsonKey(name: "Message") final  String errorMessage;

/// Create a copy of ExceptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExceptionResponseCopyWith<_ExceptionResponse> get copyWith => __$ExceptionResponseCopyWithImpl<_ExceptionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExceptionResponseToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExceptionResponse'))
    ..add(DiagnosticsProperty('statusCode', statusCode))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExceptionResponse&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExceptionResponse(statusCode: $statusCode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ExceptionResponseCopyWith<$Res> implements $ExceptionResponseCopyWith<$Res> {
  factory _$ExceptionResponseCopyWith(_ExceptionResponse value, $Res Function(_ExceptionResponse) _then) = __$ExceptionResponseCopyWithImpl;
@override @useResult
$Res call({
 int statusCode,@JsonKey(name: "Message") String errorMessage
});




}
/// @nodoc
class __$ExceptionResponseCopyWithImpl<$Res>
    implements _$ExceptionResponseCopyWith<$Res> {
  __$ExceptionResponseCopyWithImpl(this._self, this._then);

  final _ExceptionResponse _self;
  final $Res Function(_ExceptionResponse) _then;

/// Create a copy of ExceptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = null,Object? errorMessage = null,}) {
  return _then(_ExceptionResponse(
statusCode: null == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
