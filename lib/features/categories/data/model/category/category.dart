import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
sealed class Category with _$Category{
  const factory Category({
    @JsonKey(name: 'id') required String categoryId,
    @JsonKey(name: 'title') required String categoryName
  }) = _Category;
  factory Category.fromJson(Map<String, dynamic>json) =>_$CategoryFromJson(json);
}