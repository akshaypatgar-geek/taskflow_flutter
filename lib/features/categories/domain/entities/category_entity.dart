/// Domain entity for a category. Independent of data-layer models.
class CategoryEntity {
  const CategoryEntity({
    required this.categoryId,
    required this.categoryName,
  });

  final String categoryId;
  final String categoryName;
}
