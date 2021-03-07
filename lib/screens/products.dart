import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/productController.dart';
import 'package:freshology/functions/stringExtension.dart';
import 'package:freshology/models/cartModel.dart';
import 'package:freshology/models/category.dart';
import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/categoryProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/screens/home.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/widget/CartButton.dart';
import 'package:freshology/widget/productWidget.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:get/get.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import '../repositories/appListenables.dart';

class Products extends StatefulWidget {
  RouteArgument routeArgument;
  Products({Key key, this.routeArgument}) : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends StateMVC<Products>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ProductController _con;
  _ProductsState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.mainCategory = widget.routeArgument.param.mainCategory;
    _con.subCategory = widget
        .routeArgument.param.subCategory[int.parse(widget.routeArgument.id)];
    _con.fetchSubCategoryProducts();
    _con.listenForCarts();
    final category =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    _tabController = TabController(length: category.length, vsync: this);
    // setIndex();

    Future.delayed(Duration(seconds: 0), () {
      Provider.of<ProductProvider>(context, listen: false)
          .getVegetablesProducts();
      Provider.of<ProductProvider>(context, listen: false).getProducts();
      Provider.of<ProductProvider>(context, listen: false).getCat1Products();
      Provider.of<ProductProvider>(context, listen: false).getCat2Products();
      Provider.of<ProductProvider>(context, listen: false).getCat3Products();
      Provider.of<ProductProvider>(context, listen: false).getCat4Products();
    });
    super.initState();
  }

  var _size;
  // void setIndex() {
  //   final categoryProvider =
  //       Provider.of<CategoryProvider>(context, listen: false);
  //   if (categoryProvider.categoriesNames.contains(productCategory)) {
  //     _tabController.index =
  //         categoryProvider.categoriesNames.indexOf(productCategory);
  //   } else {
  //     _tabController.index = 0;
  //   }
  // }

  @override
  void dispose() {
    _tabController.dispose();
    _con.listenForCarts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final user = currentUser;
    final productList = productProvider.productList;
    _size = MediaQuery.of(context).size;

    pageCategoryTitle() {
      return Container(
        width: _size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    _con.subCategory.data.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      color: kDarkGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: kDarkGreen,
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: _con.total);
        print("CON TOTAL PRODUCTS: ${_con.total}");
        await Future.delayed(Duration(milliseconds: 200), () {});
        return true;
      },
      child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: kDarkGreen),
            title: Text(
              "Category",
              style: TextStyle(
                color: kDarkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              CartButton(cartTotal: _con.total),
            ],
          ),
          body: Column(
            children: [
              pageCategoryTitle(),
              SizedBox(height: 20),
              _con.products.length < 1
                  ? Container()
                  : Flexible(
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: _con.products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3.3),
                              itemBuilder: (BuildContext context, int index) {
                                print(
                                    "CON PRODUCTS : ${_con.products[index].name}");
                                return ProductWidget(
                                  product: _con.products[index],
                                  onPressed: () async {
                                    _con.total = await Get.to(
                                      () => (ProductDetails(
                                        routeArgument: RouteArgument(
                                          id: _con.products[index].id
                                              .toString(),
                                        ),
                                      )),
                                    );
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          )),
    );
  }
}
