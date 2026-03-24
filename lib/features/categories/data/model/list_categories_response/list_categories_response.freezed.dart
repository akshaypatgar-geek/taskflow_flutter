// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_categories_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListCategoriesResponse {

 List<Category> get categories; String? get nextCursor; bool get hasNextPage;
/// Create a copy of ListCategoriesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListCategoriesResponseCopyWith<ListCategoriesResponse> get copyWith => _$ListCategoriesResponseCopyWithImpl<ListCategoriesResponse>(this as ListCategoriesResponse, _$identity);

  /// Serializes this ListCategoriesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListCategoriesResponse&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),nextCursor,hasNextPage);

@override
String toString() {
  return 'ListCategoriesResponse(categories: $categories, nextCursor: $nextCursor, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class $ListCategoriesResponseCopyWith<$Res>  {
  factory $ListCategoriesResponseCopyWith(ListCategoriesResponse value, $Res Function(ListCategoriesResponse) _then) = _$ListCategoriesResponseCopyWithImpl;
@useResult
$Res call({
 List<Category> categories, String? nextCursor, bool hasNextPage
});




}
/// @nodoc
class _$ListCategoriesResponseCopyWithImpl<$Res>
    implements $ListCategoriesResponseCopyWith<$Res> {
  _$ListCategoriesResponseCopyWithImpl(this._self, this._then);

  final ListCategoriesResponse _self;
  final $Res Function(ListCategoriesResponse) _then;

/// Create a copy of ListCategoriesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? nextCursor = freezed,Object? hasNextPage = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ListCategoriesResponse].
extension ListCategoriesResponsePatterns on ListCategoriesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListCategoriesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListCategoriesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListCategoriesResponse value)  $default,){
final _that = this;
switch (_that) {
case _ListCategoriesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListCategoriesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ListCategoriesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Category> categories,  String? nextCursor,  bool hasNextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListCategoriesResponse() when $default != null:
return $default(_that.categories,_that.nextCursor,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Category> categories,  String? nextCursor,  bool hasNextPage)  $default,) {final _that = this;
switch (_that) {
case _ListCategoriesResponse():
return $default(_that.categories,_that.nextCursor,_that.hasNextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Category> categories,  String? nextCursor,  bool hasNextPage)?  $default,) {final _that = this;
switch (_that) {
case _ListCategoriesResponse() when $default != null:
return $default(_that.categories,_that.nextCursor,_that.hasNextPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListCategoriesResponse implements ListCategoriesResponse {
  const _ListCategoriesResponse({required final  List<Category> categories, this.nextCursor, required this.hasNextPage}): _categories = categories;
  factory _ListCategoriesResponse.fromJson(Map<String, dynamic> json) => _$ListCategoriesResponseFromJson(json);

 final  List<Category> _categories;
@override List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override final  String? nextCursor;
@override final  bool hasNextPage;

/// Create a copy of ListCategoriesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListCategoriesResponseCopyWith<_ListCategoriesResponse> get copyWith => __$ListCategoriesResponseCopyWithImpl<_ListCategoriesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListCategoriesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListCategoriesResponse&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),nextCursor,hasNextPage);

@override
String toString() {
  return 'ListCategoriesResponse(categories: $categories, nextCursor: $nextCursor, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class _$ListCategoriesResponseCopyWith<$Res> implements $ListCategoriesResponseCopyWith<$Res> {
  factory _$ListCategoriesResponseCopyWith(_ListCategoriesResponse value, $Res Function(_ListCategoriesResponse) _then) = __$ListCategoriesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Category> categories, String? nextCursor, bool hasNextPage
});




}
/// @nodoc
class __$ListCategoriesResponseCopyWithImpl<$Res>
    implements _$ListCategoriesResponseCopyWith<$Res> {
  __$ListCategoriesResponseCopyWithImpl(this._self, this._then);

  final _ListCategoriesResponse _self;
  final $Res Function(_ListCategoriesResponse) _then;

/// Create a copy of ListCategoriesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? nextCursor = freezed,Object? hasNextPage = null,}) {
  return _then(_ListCategoriesResponse(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
