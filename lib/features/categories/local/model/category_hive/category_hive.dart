
import 'package:hive_ce/hive.dart';

part 'category_hive.g.dart';

@HiveType(typeId: 3)
class CategoryHive {
@HiveField(0)
String categoryId;

@HiveField(1)
String categoryName;

CategoryHive({
  required this.categoryId,
  required this.categoryName
});
}