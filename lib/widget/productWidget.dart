import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/productModel.dart';
import 'package:freshology/provider/cartProvider.dart';
import 'package:freshology/provider/categoryProvider.dart';
import 'package:freshology/provider/userProvider.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/widget/trendingProductWidget.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  Product product;
  ProductWidget({@required this.product});

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  // Variation _currentDropDownValue;
  @override
  void initState() {
    // _currentDropDownValue = widget.product.variations[0];
    Provider.of<CategoryProvider>(context, listen: false).getCategories();
    // TODO: implement initState
    super.initState();
  }

  // List<String> _generateVariationStrings() {
  //   List<String> _var = [];
  //   widget.product.variations.forEach((variation) {
  //     _var.add(variation.vName);
  //   });
  //   return _var;
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).userDetail;
    final cartProvider = Provider.of<CartProvider>(context);
    double width = 140;
    double image_height = 120;
    List<String> option = ['500gm', '1000gm'];

    return Container(
        child: Container(
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 0.5, color: kDarkGreen),
          right: BorderSide(width: 0.5, color: kDarkGreen),
          top: BorderSide(width: 0.5, color: kDarkGreen),
          bottom: BorderSide(width: 0.5, color: kDarkGreen),
        ),
        // color: Colors.blue,
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
                    print("TASPPKED");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetails(widget.product)),
                    );
                  },
                  child: Container(
                    height: image_height,
                    width: width,
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.product.media[0].url),
                    ),
                  ),
                ),
              ),
              // (widget.product.variations.isEmpty ||
              //         widget.product.variations == null ||
              //         widget.product.variations == [])
              //     ? Positioned(
              //         right: 5,
              //         top: 5,
              //         child: Container(
              //           height: 35,
              //           width: 35,
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //               shape: BoxShape.circle, color: Colors.transparent),
              //           child: Text(
              //             widget.product.variations[0].vDiscount.toString(),
              //             style: TextStyle(
              //               color: Colors.transparent,
              //               fontSize: 11,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ),
              //       )
              //     : (widget.product.variations[0].vDiscount == null)
              //         ? Positioned(
              //             right: 5,
              //             top: 5,
              //             child: Container(
              //               height: 35,
              //               width: 35,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Colors.transparent),
              //               child: Text(
              //                 widget.product.variations[0].vDiscount.toString(),
              //                 style: TextStyle(
              //                   color: Colors.transparent,
              //                   fontSize: 11,
              //                   fontWeight: FontWeight.w700,
              //                 ),
              //               ),
              //             ),
              //           )
              //         : Positioned(
              //             right: 5,
              //             top: 5,
              //             child: Container(
              //               height: 35,
              //               width: 35,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                   shape: BoxShape.circle, color: kDarkGreen),
              //               child: Text(
              //                 widget.product.variations[0].vDiscount.toString(),
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 11,
              //                   fontWeight: FontWeight.w700,
              //                 ),
              //               ),
              //             ),
              //           ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 45,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              "${widget.product.name}",
              maxLines: 2,
              style: TextStyle(
                color: kDarkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Container(
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //     border: Border.all(color: kDarkGreen, width: 1.5),
          //   ),
          //   width: width,
          //   child: DropdownButtonFormField(
          //     isExpanded: true,
          //     isDense: true,
          //     itemHeight: 50,
          //     value: widget.product.variations[0].vName,
          //     decoration:
          //         InputDecoration.collapsed(hintText: 'select variation'),
          //     items: _generateVariationStrings()
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(
          //           value,
          //           style: TextStyle(fontSize: 13, color: kDarkGreen),
          //         ),
          //       );
          //     }).toList(),
          //     onChanged: (item) {
          //       setState(() {
          //         _currentDropDownValue = widget.product.variations
          //             .firstWhere((_variation) => _variation.vName == item);
          //       });
          //     },
          //   ),
          // ),
          SizedBox(height: 8),
          FlatButton(
            minWidth: width,
            padding: EdgeInsets.all(0),
            color: kLightGreen,
            child: Text(
              "ADD TO CART",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   child: Text(
              //     "Availability: ",
              //     style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //     ),
              //   ),
              // ),
              // Container(
              //   child: Text(
              //     "${widget.product.deliveryDate.day}/${widget.product.deliveryDate.month}/${widget.product.deliveryDate.year}",
              //     style: TextStyle(
              //       color: kDarkGreen,
              //       fontSize: 12,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    ));
  }
}
