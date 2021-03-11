import 'package:flutter/material.dart';
import 'package:freshology/models/categoryModel.dart';
import 'package:freshology/models/offerModel.dart';
// import 'package:freshology/models/productModel.dart';
import 'package:freshology/provider/offersProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:image_slider/image_slider.dart';
import 'package:provider/provider.dart';

class BannerScrollableCategory extends StatefulWidget {
  int length;
  List<CategoryModel> offersList;
  BannerScrollableCategory({this.length, this.offersList});
  @override
  _BannerScrollableCategoryState createState() =>
      _BannerScrollableCategoryState();
}

List<Container> carMockList = [
  Container(),
  Container(),
];
int _tabLength = 0;
TabController _tabController;

class _BannerScrollableCategoryState extends State<BannerScrollableCategory>
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
    // final productProvider = Provider.of<ProductProvider>(context);
    final offersList = widget.offersList;
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 20),
        (offersList.length > 0)
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
                children: offersList.length != 0
                    ? offersList.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GestureDetector(
                                onTap: () {
                                  // productProvider.selectedCategoryName = i.name;
                                  // Navigator.pushNamed(context, 'products');
                                },
                                child: Image(
                                  image: NetworkImage(i.imageUrl),
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
