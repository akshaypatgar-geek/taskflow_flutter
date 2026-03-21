import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskflowapp/features/categories/data/model/category/category.dart';

part 'list_categories_response.freezed.dart';
part 'list_categories_response.g.dart';

@freezed
sealed class ListCategoriesResponse with _$ListCategoriesResponse{
  const factory ListCategoriesResponse({
    required List<Category> categories,
    String? nextCursor,
    required bool hasNextPage
  }) = _ListCategoriesResponse;
  factory ListCategoriesResponse.fromJson(Map<String, dynamic>json) =>_$ListCategoriesResponseFromJson(json);
}