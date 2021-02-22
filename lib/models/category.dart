import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/subCategory.dart';

class Category {
  MainCategory mainCategory;
  List<SubCategory> subCategory;

  Category({
    this.mainCategory,
    this.subCategory,
  });
}
