import 'package:freshology/models/category.dart';
import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:freshology/repositories/product_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProductController extends ControllerMVC {
  List<Product> products = [];
  SubCategory subCategory;
  MainCategory mainCategory;
  fetchSubCategoryProducts() async {
    var response = await getSubCategoryProducts(subCategory.id.toString());
    if (response != null) {
      products = response;
      print("PRODUCTS LIST LENGTH: ${products.length}");
      setState(() {});
    } else {
      products = [];
    }
  }
}
