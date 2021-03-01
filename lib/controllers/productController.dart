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
    final Stream<Product> stream =
        await getFoodsByCategory(subCategory.data.id.toString());
    stream.listen(
        (Product _product) {
          setState(() {
            products.add(_product);
          });
        },
        onError: (a) {},
        onDone: () {
          setState(() {});
          // if (message != null) {
          //   scaffoldKey.currentState.showSnackBar(SnackBar(
          //     content: Text(message),
          //   ));
          // }
        });
  }
}
