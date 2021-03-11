// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:freshology/provider/productProvider.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:freshology/provider/cartProvider.dart';
// import 'package:freshology/constants/styles.dart';

// class FloatAppBar extends StatelessWidget with PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     final names = Provider.of<ProductProvider>(context).productNames;
//     final searchRef = Provider.of<ProductProvider>(context);
//     final cartProvider = Provider.of<CartProvider>(context);
//     return Stack(
//       children: <Widget>[
//         // Positioned(
//         //   top: 50,
//         //   child: Expanded(
//         //     child: AutoCompleteTextField<String>(
//         //       itemSubmitted: (value) {
//         //         print(value);
//         //         searchRef.searchItemName = value;
//         //         Provider.of<ProductProvider>(context, listen: false)
//         //             .getSearchProduct(context);
//         //         FocusScope.of(context).unfocus();
//         //       },
//         //       key: null,
//         //       decoration: InputDecoration(
//         //         focusedBorder: OutlineInputBorder(
//         //           borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
//         //         ),
//         //         enabledBorder: OutlineInputBorder(
//         //           borderSide: BorderSide(color: Colors.red, width: 5.0),
//         //         ),
//         //         border: InputBorder.none,
//         //         contentPadding: EdgeInsets.symmetric(horizontal: 15),
//         //         hintText: "Search",
//         //       ),
//         //       suggestions: names,
//         //       itemBuilder: (context, item) {
//         //         return ListTile(
//         //           title: Text(item),
//         //         );
//         //       },
//         //       itemSorter: (a, b) {
//         //         return a.compareTo(b);
//         //       },
//         //       itemFilter: (name, query) {
//         //         return name.toLowerCase().contains(query.toLowerCase());
//         //       },
//         //     ),
//         //   ),
//         // ),
//         Positioned(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Material(
//                   type: MaterialType.transparency,
//                   child: IconButton(
//                     splashColor: Colors.grey,
//                     icon: Icon(Icons.menu),
//                     onPressed: () {
//                       Scaffold.of(context).openDrawer();
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: AutoCompleteTextField<String>(
//                     itemSubmitted: (value) {
//                       print(value);
//                       searchRef.searchItemName = value;
//                       Provider.of<ProductProvider>(context, listen: false)
//                           .getSearchProduct(context);
//                       FocusScope.of(context).unfocus();
//                     },
//                     key: null,
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(color: Colors.greenAccent, width: 5.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.red, width: 5.0),
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 15),
//                       hintText: "Search",
//                     ),
//                     suggestions: names,
//                     itemBuilder: (context, item) {
//                       return ListTile(
//                         title: Text(item),
//                       );
//                     },
//                     itemSorter: (a, b) {
//                       return a.compareTo(b);
//                     },
//                     itemFilter: (name, query) {
//                       return name.toLowerCase().contains(query.toLowerCase());
//                     },
//                   ),
//                 ),
//                 Container(
//                   child: Image(
//                     image: AssetImage(
//                       'assets/logo_text.png',
//                     ),
//                     width: 200,
//                     height: 50,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, 'notify');
//                   },
//                   child: Icon(
//                     Icons.notifications,
//                     size: 30,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 // GestureDetector(
//                 //   onTap: () {
//                 //     Navigator.pushNamed(context, 'cart');
//                 //   },
//                 //   child: Icon(
//                 //     Icons.shopping_cart,
//                 //     size: 30,
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   width: 10,
//                 // ),
//                 // Container(
//                 //   height: 30,
//                 //   alignment: Alignment.center,
//                 //   width: 30,
//                 //   decoration: BoxDecoration(
//                 //     shape: BoxShape.circle,
//                 //     color: kLightGreen,
//                 //   ),
//                 //   child: Text(
//                 //     cartProvider.itemCount.toString(),
//                 //     style: TextStyle(
//                 //       fontSize: 16,
//                 //       color: Colors.white,
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   width: 5,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

// //Expanded(
// //child: TextField(
// //cursorColor: Colors.black,
// //keyboardType: TextInputType.text,
// //textInputAction: TextInputAction.go,
// //decoration: InputDecoration(
// //border: InputBorder.none,
// //contentPadding: EdgeInsets.symmetric(horizontal: 15),
// //hintText: "Search your product here",
// //),
// //onChanged: (value) {
// //searchRef.searchItemName = value;
// //},
// //onSubmitted: (value) {
// //searchRef.searchItemName = value;
// //Provider.of<ProductProvider>(context, listen: false)
// //    .getSearchProduct(context);
// //FocusScope.of(context).unfocus();
// //},
// //),
// //),
