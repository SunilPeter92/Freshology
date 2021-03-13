import 'package:freshology/helpers/helper.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/category.dart';
import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:freshology/repositories/appListenables.dart';
import 'package:freshology/repositories/cart_repository.dart';
import 'package:freshology/repositories/product_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProductController extends ControllerMVC {
  List<Product> products = [];
  SubCategory subCategory;
  MainCategory mainCategory;
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double quantity = 1;
  double total = 0;
  Cart cart;
  // Favorite favorite;
  bool loadCart = false;

  void listenForCarts({String message, isGrocery = false}) async {
    if (currentUser.value.apiToken != null) {
      final Stream<Cart> stream = await getCart();
      stream.listen((Cart _cart) {
        if (!carts.contains(_cart)) {
          setState(() {
            carts.add(_cart);
          });
        }
      }, onError: (a) {
        print(a);
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text('Verify your internet connection'),
        // ));
      }, onDone: () {
        calculateSubtotal();
        if (message != null) {
          // scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(message),
          // ));
        }
      });
    }
  }

  void calculateSubtotal() {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.product.price;
    });
//    taxAmount = subTotal * settingRepo.setting.defaultTax / 100;
    total = subTotal + taxAmount;

    setState(() {});
  }

  fetchSubCategoryProducts() async {
    final Stream<Product> stream =
        await getFoodsByCategory(subCategory.data.id.toString());

    stream.listen(
        (Product _product) {
          _product.media[0].url = Helper.imageURLFixer(_product.media[0].url);
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
