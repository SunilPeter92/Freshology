import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/cartModel.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/productModel.dart';
import 'package:freshology/models/userModel.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/repositories/user_repository.dart';
import 'package:freshology/widget/CartButton.dart';
import 'package:freshology/widget/startButton.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  Product product;
  ProductDetails(this.product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var _size;
  TextEditingController _controller;
  addMoneyPresetWidget(String weight, String price) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: _controller.text == weight ? kDarkGreen : kLightGreen,
        ),
        borderRadius: BorderRadius.circular(15),
        color: _controller.text == weight ? kDarkGreen : Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.text = weight;
          });
        },
        child: Column(
          children: [
            Text(
              "${weight}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _controller.text == weight ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "₹ ${price}",
              style: TextStyle(
                fontSize: 12,
                color: _controller.text == weight ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildVariations() {
  //   List<Widget> variationsList = [];
  //   widget.product.variations.forEach((variation) {
  //     variationsList.add(
  //       addMoneyPresetWidget(
  //         variation.vName.toString(),
  //         variation.vPrice.toString(),
  //       ),
  //     );
  //   });
  //   return variationsList;
  // }

  //////// TODO: MAKE USER OBJECT MANAGED BY STATE ////////
  User user;
  @override
  void initState() {
    // TODO: implement initState
    user = currentUser.value;
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomSheet: Container(
        width: _size.width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "QUANTITY",
              style: TextStyle(
                color: kDarkGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // CartModel cartItem = CartModel(
                //   productName: widget.product.pName,
                //   productImageUrl: widget.product.pImage,
                //   productPrice: widget.product.defaultPriceIndex,
                //   productQuantity: 1,
                //   productTotalPrice: int.parse(widget.product.defaultPriceIndex),
                //   productWeight: widget.product.weight,
                //   sGST: widget.product.sGST,
                //   sKU: widget.product.sKU,
                //   iGST: widget.product.iGST,
                //   cGST: widget.product.cGST,
                //   hSN: widget.product.hSN,
                // );

                // if (user.userId != null) {
                //   setState(() {
                //     widget.product.quantity++;
                //     cartProvider.addToCart(cartItem);
                //   });
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
              child: Container(
                width: 100,
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Text(
                  "Add +",
                  style: TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  border: Border.all(
                    color: kDarkGreen,
                    width: 2,
                  ),
                ),
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.grey, width: 0.8)),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: kLightGreen,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        actions: [
          CartButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 270,
              width: _size.width,
              child: Image(
                fit: BoxFit.contain,
                image: NetworkImage(widget.product.media[0].url),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              width: _size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _size.width * 0.65,
                    alignment: Alignment.topLeft,
                    child: AutoSizeText(
                      "${widget.product.name} ",
                      maxFontSize: 20,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: _size.width * 0.28,
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            "₹ ${widget.product.price}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            "${widget.product.price}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Availability: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Container(
                  //   child: Text(
                  //     "${widget.product.deliveryDate.day}/${widget.product.deliveryDate.month}/${widget.product.deliveryDate.year}",
                  //     style: TextStyle(
                  //       color: kDarkGreen,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              height: _size.height * 0.2,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: AutoSizeText(
                widget.product.description,
                textAlign: TextAlign.left,
                minFontSize: 10,
                style: TextStyle(fontSize: 12, color: Colors.grey[800]),
              ),
            ),
            SizedBox(height: 10),
            // Container(
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: _buildVariations()),
            // ),
          ],
        ),
      ),
    );
  }
}
