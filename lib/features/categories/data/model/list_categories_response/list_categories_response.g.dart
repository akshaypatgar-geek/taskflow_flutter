// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListCategoriesResponse _$ListCategoriesResponseFromJson(
  Map<String, dynamic> json,
) => _ListCategoriesResponse(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => Category.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['nextCursor'] as String?,
  hasNextPage: json['hasNextPage'] as bool,
);

Map<String, dynamic> _$ListCategoriesResponseToJson(
  _ListCategoriesResponse instance,
) => <String, dynamic>{
  'categories': instance.categories,
  'nextCursor': instance.nextCursor,
  'hasNextPage': instance.hasNextPage,
};
