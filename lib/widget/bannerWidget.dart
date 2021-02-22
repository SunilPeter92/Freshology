import 'package:flutter/material.dart';
import 'package:freshology/models/offerModel.dart';
import 'package:freshology/models/productModel.dart';
import 'package:freshology/provider/offersProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:image_slider/image_slider.dart';
import 'package:provider/provider.dart';

class BannerScrollable extends StatefulWidget {
  int length;
  List<OffersModel> offersList;
  BannerScrollable({this.length, this.offersList});
  @override
  _BannerScrollableState createState() => _BannerScrollableState();
}

List<Container> carMockList = [
  Container(),
  Container(),
];
int _tabLength = 0;
TabController _tabController;

class _BannerScrollableState extends State<BannerScrollable>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: widget.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final offersProvider = Provider.of<OffersProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final offersList = widget.offersList;
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 20),
        (widget.offersList.length > 0)
            ? ImageSlider(
                showTabIndicator: false,
                tabIndicatorColor: Colors.lightBlue,
                tabIndicatorSelectedColor: Color.fromARGB(255, 0, 0, 255),
                tabIndicatorHeight: 16,
                tabIndicatorSize: 16,
                tabController: _tabController,
                curve: Curves.fastOutSlowIn,
                width: size.width,
                height: 220,
                autoSlide: true,
                duration: new Duration(seconds: 5),
                allowManualSlide: true,
                children: widget.offersList.length != 0
                    ? widget.offersList.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GestureDetector(
                                onTap: i.clickable != null
                                    ? () {
                                        if (i.clickable == true) {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           ProductDetails(ProductModel(
                                          //               price: i.price,
                                          //               weight: i.weight,
                                          //               description:
                                          //                   i.description,
                                          //               name: i.name,
                                          //               sGST: i.sGST.toDouble(),
                                          //               iGST: i.iGST.toDouble(),
                                          //               cGST: i.cGST.toDouble(),
                                          //               hSN: i.hSN,
                                          //               sKU: i.sKU,
                                          //               quantity: 0,
                                          //               imageUrl: i.image))),
                                          // );
                                        }
                                      }
                                    : () {
                                        productProvider.selectedProduct =
                                            ProductModel(
                                          imageUrl: i.image,
                                          description: i.description,
                                          price: i.price,
                                          weight: i.weight,
                                          name: i.name,
                                          cGST: i.cGST,
                                          sGST: i.sGST,
                                          sKU: i.sKU,
                                          iGST: i.iGST,
                                          hSN: i.hSN,
                                          quantity: 0,
                                        );
                                      },
                                child: Image(
                                  image: NetworkImage(i.offers),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList()
                    : carMockList,
              )
            : Container(),
        SizedBox(height: 10),
      ],
    );
  }
}
