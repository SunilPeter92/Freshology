import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/cartModel.dart';
import 'package:freshology/models/productModel.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:provider/provider.dart';

class TrendingProductsWidget extends StatelessWidget {
  Function buttonPressed;

  ProductModel product;
  TrendingProductsWidget(
      {@required this.product, @required this.buttonPressed});
  UserModel user;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    user = currentUser.value;
    double width = 120;
    double image_height = 150;
    return Container(
      width: width,

      // padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: kDarkGreen,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ProductDetails(product)),
                    // );
                  },
                  child: Container(
                    height: image_height,
                    width: width,
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.imageUrl),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: kDarkGreen),
                  child: Text(
                    "13%\nOFF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 25,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "₹ ${product.price}",
                    style: TextStyle(
                      color: kDarkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 25,
                  alignment: Alignment.topLeft,
                  child: Text(
                    "₹ ${product.price}",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: width,
            child: AutoSizeText(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              maxFontSize: 12,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          RaisedButton(
            color: kLightGreen,
            child: Text(
              "ADD TO CART",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              CartModel cartItem = CartModel(
                productName: product.name,
                productImageUrl: product.imageUrl,
                productPrice: product.price,
                productQuantity: 1,
                productTotalPrice: int.parse(product.price),
                productWeight: product.weight,
                sGST: product.sGST,
                sKU: product.sKU,
                iGST: product.iGST,
                cGST: product.cGST,
                hSN: product.hSN,
              );

              if (user.userId != null) {
                product.quantity++;
                cartProvider.addToCart(cartItem);
                buttonPressed();
                // setState(() {
                //   widget.product.quantity++;
                //   cartProvider.addToCart(cartItem);
                // });
              } else {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
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
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'Please sign up '
                              'before adding items in the '
                              'cart.',
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
            },
          )
        ],
      ),
    );
  }
}