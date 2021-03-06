import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freshology/models/product_order.dart';
import 'package:freshology/repositories/settings_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

//   static Future<Marker> getMarker(Map<String, dynamic> res) async {
//     final Uint8List markerIcon =
//         await getBytesFromAsset('assets/img/marker.png', 120);
//     final Marker marker = Marker(
//         markerId: MarkerId(res['id']),
//         icon: BitmapDescriptor.fromBytes(markerIcon),
// //        onTap: () {
// //          //print(res.name);
// //        },
//         anchor: Offset(0.5, 0.5),
//         infoWindow: InfoWindow(
//             title: res['name'],
//             snippet: res['distance'].toStringAsFixed(2) + ' mi',
//             onTap: () {
//               print('infowi tap');
//             }),
//         position: LatLng(
//             double.parse(res['latitude']), double.parse(res['longitude'])));

//     return marker;
//   }
  static String imageURLFixer(String badUrl) {
    String url;
    url = badUrl.replaceFirst("publicstorage", "public/storage");
    return url;
  }

  static Future<void> launchInWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }



  static String availabilityChecker(String d){
  DateTime date = DateTime.parse(d);

        DateTime now = DateTime.now();

      int diff =  DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;

      if(diff == -1){
        return "Yesterday";
      }else if(diff == 0){
        return "Today";
      }else if(diff == 1){
        return "Tomorrow";
      }else{
        return "${date.day}/${date.month}/${date.year}";
      }
    }

  Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Icon getBackIcon(
      {bool isAppBar = false,
      BuildContext context,
      bool isWhite = false,
      bool isBlack = false}) {
    if (Platform.isAndroid) {
      return Icon(
        Icons.arrow_back,

//        color: isAppBar ? Provider.of<ThemeChange>(context).isDark ? AppColors.WHITE : AppColors.BLACK : AppColors.WHITE,
        color: isBlack
            ? Colors.black
            : isWhite
                ? Colors.white
                : Colors.grey,
      );
      // Android-specific code
    } else if (Platform.isIOS) {
      return Icon(
        Icons.arrow_back_ios,
//        color: isAppBar ? Provider.of<ThemeChange>(context).isDark ? AppColors.WHITE : AppColors.BLACK : AppColors.WHITE,
        color: isBlack
            ? Colors.black
            : isWhite
                ? Colors.white
                : Colors.grey,
      );
      // iOS-specific code
    }
  }

  static Widget checkboctitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }

  static Widget getbackIconWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          child: Container(
            child: Helper.getBackIcon(isAppBar: true, context: context),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // static Future<Marker> getMyPositionMarker(
  //     double latitude, double longitude) async {
  //   final Uint8List markerIcon =
  //       await getBytesFromAsset('assets/img/my_marker.png', 120);
  //   final Marker marker = Marker(
  //       markerId: MarkerId(Random().nextInt(100).toString()),
  //       icon: BitmapDescriptor.fromBytes(markerIcon),
  //       anchor: Offset(0.5, 0.5),
  //       position: LatLng(latitude, longitude));

  //   return marker;
  // }

  static List<Icon> getStarsList(double rate) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: 18, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: 18, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: 18, color: Color(0xFFFFB24D));
    }));
    return list;
  }

//  static Future<List> getPriceWithCurrency(double myPrice) async {
//    final Setting _settings = await getCurrentSettings();
//    List result = [];
//    if (myPrice != null) {
//      result.add('${myPrice.toStringAsFixed(2)}');
//      if (_settings.currencyRight) {
//        return '${myPrice.toStringAsFixed(2)} ' + _settings.defaultCurrency;
//      } else {
//        return _settings.defaultCurrency + ' ${myPrice.toStringAsFixed(2)}';
//      }
//    }
//    if (_settings.currencyRight) {
//      return '0.00 ' + _settings.defaultCurrency;
//    } else {
//      return _settings.defaultCurrency + ' 0.00';
//    }
//  }

  static Widget getPrice(double myPrice, BuildContext context,
      {TextStyle style}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: setting.value?.defaultCurrency,
                style: style ?? Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(2) ?? '',
                      style: style ?? Theme.of(context).textTheme.subhead),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(2) ?? '',
                style: style ?? Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                      text: setting.value?.defaultCurrency,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: style != null
                              ? style.fontSize - 4
                              : Theme.of(context).textTheme.subhead.fontSize -
                                  4)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(
      ProductOrder foodOrder, double tax, double deliveryFee) {
    double total = 0 ;
    // double total = foodOrder.price * foodOrder.quantity;

    for(int i = 0 ; i<foodOrder.extras.length;i++){
      total = total + (foodOrder.extras[i].price * foodOrder.quantity);
    }


    // foodOrder.food.extras.forEach((extra) {
    //   total += extra.price != null ? extra.price : 0;
    // });
    // total += deliveryFee;
    // total += tax * total / 100;
    return total;
  }

  static String getDistance(double distance) {
    // TODO get unit from settings
    return distance != null ? distance.toStringAsFixed(2) + " mi" : "";
  }

  // static String skipHtml(String htmlString) {
  //   var document = parse(htmlString);
  //   String parsedString = parse(document.body.text).documentElement.text;
  //   return parsedString;
  // }

  // static Html applyHtml(context, String html, {TextStyle style}) {
  //   return Html(
  //     blockSpacing: 0,
  //     data: html,
  //     defaultTextStyle: style ??
  //         Theme.of(context).textTheme.body2.merge(TextStyle(fontSize: 14)),
  //     useRichText: false,
  //     customRender: (node, children) {
  //       if (node is dom.Element) {
  //         switch (node.localName) {
  //           case "br":
  //             return SizedBox(
  //               height: 0,
  //             );
  //           case "p":
  //             return Padding(
  //               padding: EdgeInsets.only(top: 0, bottom: 0),
  //               child: Container(
  //                 width: double.infinity,
  //                 child: Wrap(
  //                   crossAxisAlignment: WrapCrossAlignment.center,
  //                   alignment: WrapAlignment.start,
  //                   children: children,
  //                 ),
  //               ),
  //             );
  //         }
  //       }
  //       return null;
  //     },
  //   );
  // }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }
}
