import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/cartModel.dart';
import 'package:freshology/models/productModel.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:provider/provider.dart';

class Item extends StatefulWidget {
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final item = productProvider.selectedProduct;
    final user = Provider.of<UserProvider>(context).userDetail;
    List<ProductModel> products =
        productProvider.selectedCategoryName == 'fruits'
            ? productProvider.fruitsProductList
            : productProvider.vegetablesProductList;
    //products = products.shuffle();
    products.shuffle();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightGreen,
        title: Text(item.name),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 12,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: NetworkImage(item.imageUrl),
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                      item.description != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 0,
                                    ),
//                                    decoration: BoxDecoration(
//                                      border: Border(
//                                        bottom: BorderSide(
//                                          width: 2,
//                                          color: kDarkGreen,
//                                        ),
//                                      ),
//                                    ),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(item.description ?? ''),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  item.weight,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "₹ " + item.price,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantity : ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(9),
                                        bottomLeft: Radius.circular(9),
                                      ),
                                      color: Colors.blueGrey[100],
                                    ),
                                    width: 35,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (quantity > 0) {
                                          setState(() {
                                            quantity = quantity - 1;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: kDarkGreen,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      quantity.toString(),
                                      textAlign: TextAlign.center,
                                      style: kProductNameTextStyle,
                                    ),
                                    width: 30,
                                  ),
                                  Container(
                                    width: 35,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(9),
                                        bottomRight: Radius.circular(9),
                                      ),
                                      color: Colors.blueGrey[100],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity = quantity + 1;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 25,
                                        color: kDarkGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                'Related Products',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 180,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      products.length > 5 ? 5 : products.length,
                                  itemBuilder: (context, index) {
                                    var product = products[index];
                                    return product.name != item.name
                                        ? GestureDetector(
                                            onTap: () {
                                              productProvider.selectedProduct =
                                                  product;
                                              Navigator.pushNamed(
                                                  context, 'item');
                                            },
                                            child: Container(
                                              width: 125,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.black38,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Image(
                                                    image: NetworkImage(
                                                        product.imageUrl),
                                                    height: 100,
                                                    width: 150,
                                                  ),
                                                  Text(
                                                    product.name,
                                                    style:
                                                        kProductNameTextStyle,
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "₹ " + product.price,
                                                    style:
                                                        kProductPriceTextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
                  onPressed: quantity > 0
                      ? () {
                          if (user.id != null) {
                            CartModel cartItem = CartModel(
                              productName: item.name,
                              productImageUrl: item.imageUrl,
                              productPrice: item.price,
                              productQuantity: quantity,
                              productTotalPrice: int.parse(item.price),
                              productWeight: item.weight,
                              iGST: item.iGST,
                              cGST: item.cGST,
                              sGST: item.sGST,
                              sKU: item.sKU,
                              hSN: item.hSN,
                            );
                            Provider.of<CartProvider>(context, listen: false)
                                .addToCart(cartItem);
                            Fluttertoast.showToast(msg: 'Added');
                          } else {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 40,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          'Hey Guest!',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: kDarkGreen,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          'Please sign up before adding items in '
                                          'the cart.',
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      StartButton(
                                        name: 'Sign Up',
                                        onPressFunc: () {
                                          Navigator.pushNamed(context, 'start');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                      : () {
                          Fluttertoast.showToast(msg: 'Select quantity');
                        },
                  child: Text(
                    'Add to cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  color: kLightGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
