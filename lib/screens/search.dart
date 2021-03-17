import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:freshology/controllers/SearchController.dart';
import 'package:freshology/models/route.dart';
import 'package:freshology/screens/productDetails.dart';
import 'package:freshology/widget/productWidget.dart';
import 'package:get/get.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends StateMVC<SearchPage> {
  SearchController _con;

  _SearchPageState() : super(SearchController()) {
    _con = controller;
  }

  TextEditingController _controller = TextEditingController();

  ScrollController _scrollController;
  @override
  initState() {

    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _con.scaffoldKey,
      child: Scaffold(
          body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.black),
              // leading: Container(),
              title: Container(
                child: Image(
                  image: AssetImage(
                    'assets/logo_text.png',
                  ),
                  width: 200,
                  height: 50,
                ),
              ),
              actions: [
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'favorites');
                    },
                    child: Icon(
                      FontAwesomeIcons.heart,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 15)
              ],
              backgroundColor: Colors.white,
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              centerTitle: true,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: StickyHeader(
              header: Container(

                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset:
                      Offset(01, 01), // changes position of shadow
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap:(){
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.blue,
                            width:250,
                            height: 20,
                          margin: EdgeInsets.only(top:18,left:10),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _controller,
                      autofocus: true,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          // contentPadding:
                          // EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          alignLabelWithHint: false,
                          hintText: "Search"),
                            onSubmitted: (val){
                              _con.listenForSearch(search:val.toString());

                            },


                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(right:10),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // child: AutoCompleteTextField<String>(
                //
                //   itemSubmitted: (value) {
                //     print(value);
                //     // searchRef.searchItemName = value;
                //     // Provider.of<ProductProvider>(context, listen: false)
                //     //     .getSearchProduct(context);
                //     Navigator.pushNamed(context,'search');
                //     FocusScope.of(context).unfocus();
                //   },
                //   key: null,
                //   decoration: InputDecoration(
                //     suffixIcon: Icon(
                //       Icons.search,
                //       color: Colors.grey,
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(50),
                //       ),
                //       borderSide:
                //       BorderSide(color: Colors.transparent, width: 1.5),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(50),
                //       ),
                //       borderSide:
                //       BorderSide(color: Colors.transparent, width: 1.5),
                //     ),
                //     border: InputBorder.none,
                //     contentPadding: EdgeInsets.symmetric(horizontal: 15),
                //     hintText: "Search",
                //   ),
                //   // suggestions: names,
                //   itemBuilder: (context, item) {
                //     return ListTile(
                //       leading: Icon(
                //         Icons.search,
                //         color: kLightGreen,
                //       ),
                //       title: Text(
                //         item,
                //       ),
                //     );
                //   },
                //   itemSorter: (a, b) {
                //     return a.compareTo(b);
                //   },
                //   itemFilter: (name, query) {
                //     return name.toLowerCase().contains(query.toLowerCase());
                //   },
                // ),
              ),
              content: Container(
                padding:EdgeInsets.all(10),
                // color: Colors.blue,
                height: MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // pageCategoryTitle(),
                    SizedBox(height: 20),
                    _con.products.length < 1
                        ? Container()
                        : Flexible(
                      child: Column(
                        children: [
                          GridView.builder(
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
                                   await Get.to(
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
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      )

          //  _selectedIndex == 1
          //     ?
          //     : _widgetOptions.elementAt(_selectedIndex),
          ),
    );
  }
}
