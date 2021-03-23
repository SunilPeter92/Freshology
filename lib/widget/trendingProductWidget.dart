import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshology/helpers/helper.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/home_controller.dart';
import 'package:freshology/models/cartModel.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/route.dart';
// import 'package:freshology/models/productModel.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:provider/provider.dart';
import '../repositories/appListenables.dart';

class TrendingProductsWidget extends StatelessWidget {
  Function buttonPressed;

  Product product;
  TrendingProductsWidget(
      {@required this.product, @required this.buttonPressed});
  User user;
  HomeController _con;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    user = currentUser.value;
    double width = 120;
    double image_height = 150;
    return InkWell(
      onTap: (){
        buttonPressed();
      } ,
      child: Container(
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
                  child: Container(
                    height: image_height,
                    width: width,
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.media[0].url),
                    ),
                  ),
                ),
                (product.discountPrice / product.price) == 0
                    ? Positioned(
                        right: 5,
                        top: 5,
                        child: Container(),
                      )
                    : Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          height: 35,
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: kDarkGreen),
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
            SizedBox(height: 5),
            Container(
              width: width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (product.discountPrice == 0 || product.discountPrice == null)
                      ? Container(
                          height: 25,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "₹ ${product.extras[0].price}",
                            style: TextStyle(
                              color: kDarkGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          height: 25,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "₹ ${product.discountPrice}",
                            style: TextStyle(
                              color: kDarkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  SizedBox(width: 10),
                  (product.discountPrice == 0 || product.discountPrice == null)
                      ? Container()
                      : Container(
                          height: 25,
                          alignment: Alignment.topLeft,
                          child: Text(
                            "₹ ${product.extras[0].price}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              height: 30,
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
                buttonPressed();
                // CartModel cartItem = CartModel(
                //   productName: product.name,
                //   productImageUrl: product.imageUrl,
                //   productPrice: product.price,
                //   productQuantity: 1,
                //   productTotalPrice: int.parse(product.price),
                //   productWeight: product.weight,
                //   sGST: product.sGST,
                //   sKU: product.sKU,
                //   iGST: product.iGST,
                //   cGST: product.cGST,
                //   hSN: product.hSN,
                // );

                // if (user.id != null) {
                //   product.quantity++;
                //   cartProvider.addToCart(cartItem);
                //   buttonPressed();
                //   // setState(() {
                //   //   widget.product.quantity++;
                //   //   cartProvider.addToCart(cartItem);
                //   // });
                // } else {
                //   showModalBottomSheet(
                //     context: context,
                //     builder: (context) {
                //       return Container(
                //         padding: EdgeInsets.symmetric(
                //           vertical: 20,
                //           horizontal: 40,
                //         ),
                //         height: MediaQuery.of(context).size.height * 0.25,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: <Widget>[
                //             Container(
                //               width: MediaQuery.of(context).size.width,
                //               child: Text(
                //                 'Hey Guest!',
                //                 textAlign: TextAlign.start,
                //                 style: TextStyle(
                //                   fontSize: 20,
                //                   fontWeight: FontWeight.w700,
                //                   color: kDarkGreen,
                //                 ),
                //               ),
                //             ),
                //             Container(
                //               width: MediaQuery.of(context).size.width,
                //               child: Text(
                //                 'Please sign up '
                //                 'before adding items in the '
                //                 'cart.',
                //                 textAlign: TextAlign.start,
                //               ),
                //             ),
                //             StartButton(
                //               name: 'Sign Up',
                //               onPressFunc: () {
                //                 Navigator.pushNamed(context, 'start');
                //               },
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   );
                // }
              },
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Availability: ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    Helper.availabilityChecker(product.availability),
                    style: TextStyle(
                      color: kDarkGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),          ],
        ),
      ),
    );
  }
}
