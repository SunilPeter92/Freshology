import 'package:flutter/material.dart';
import 'package:freshology/models/offerModel.dart';
// import 'package:freshology/models/productModel.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/models/slides.dart';
import 'package:freshology/provider/offersProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:image_slider/image_slider.dart';
import 'package:provider/provider.dart';

class BannerScrollable extends StatefulWidget {
  int length;
  List<Slide> slidesList;
  Function onPressed;
  BannerScrollable({this.length, this.slidesList, this.onPressed});
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
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    // _tabController =
    //     TabController(length: widget.slidesList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final offersProvider = Provider.of<OffersProvider>(context);
    // print("TABS LENGTH: ${_tabController.length}");
    // print("WIDGET LIST LENGTH: ${widget.slidesList.length}");
    // print("WIDGET LENGTH: ${widget.length}");
    _tabController =
        TabController(length: widget.slidesList.length, vsync: this);
    // final productProvider = Provider.of<ProductProvider>(context);
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 20),
        (widget.slidesList.length > 1)
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
                children: widget.slidesList.length != 0
                    ? widget.slidesList.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                            width: size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: GestureDetector(
                                onTap: i.enabled != null
                                    ? () {
                                        if (i.enabled == true) {
                                          widget.onPressed(i);
                                        }
                                      }
                                    : () {},
                                child: Image(
                                  image: NetworkImage(i.media[0].url),
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
