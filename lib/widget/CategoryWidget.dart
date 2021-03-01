import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/home_controller.dart';
import 'package:freshology/functions/stringExtension.dart';
import 'package:freshology/models/category.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:freshology/provider/categoryProvider.dart';
import 'package:freshology/provider/productProvider.dart';
import 'package:freshology/widget/productBox.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  Category category;
  CategoryWidget({this.category});
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  var size;
  List<Widget> catWidget = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    // final categoryList = Provider.of<CategoryProvider>(context).categories;
    // final productProvider = Provider.of<ProductProvider>(context);

    buildCategory(String mainCatName) {
      return ConfigurableExpansionTile(
        headerExpanded: Container(
          width: size.width * 0.97,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: kLightGreen.withOpacity(0.15),
            border: Border.all(color: kDarkGreen, width: 1.5),
          ),
          child: Container(
            child: Row(
              children: [
                Container(
                  child: Image(
                    image: AssetImage("assets/fruitsandveg.png"),
                    height: 70,
                    width: 70,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.68,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                mainCatName.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          "Lorem Ipsum is simply dummy text\nof the printing and typesetting ",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        header: Container(
          width: size.width * 0.97,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(color: kDarkGreen, width: 1.5),
          ),
          child: Container(
            child: Row(
              children: [
                Container(
                  child: Image(
                    image: AssetImage("assets/fruitsandveg.png"),
                    height: 70,
                    width: 70,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.68,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                widget.category.mainCategory.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kDarkGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          "Lorem Ipsum is simply dummy text\nof the printing and typesetting ",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        children: [
          SizedBox(height: 10),
          widget.category.subCategory.length < 1
              ? Container()
              : Container(
                  height: (widget.category.subCategory.length / 2.5)
                          .roundToDouble() *
                      150.0,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: widget.category.subCategory.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kDarkGreen, width: 0.2),
                        ),
                        margin: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('products',
                                arguments: RouteArgument(
                                    id: index.toString(),
                                    param: widget.category));
                            // productProvider.selectedCategoryName =
                            //     categoryList[index].name;
                            // Navigator.pushNamed(context, 'products');
                          },
                          child: ProductBox(
                            imagePath:
                                widget.category.subCategory[index].smedia,
                            name: capitalize(
                                widget.category.subCategory[index].data.name),
                          ),
                        ),
                      );
                    },
                  ),
                ),

          SizedBox(
            height: 10,
          )
          // + more params, see example !!
        ],
      );
    }

    return buildCategory("${widget.category.mainCategory.name}");
  }
}
