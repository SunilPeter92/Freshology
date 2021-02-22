import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshology/constants/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshology/models/Announcement.dart';

class AnnouncementWidget extends StatelessWidget {
  Announcement announcement;
  AnnouncementWidget({this.announcement});
  var _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: kLightGreen,
          width: 1.5,
        ),
      ),
      child: Container(
        height: 80,
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Icon(
                FontAwesomeIcons.bullhorn,
              ),
              transform: Matrix4.rotationZ(-0.474533),
            ),
            Container(
              width: _size.width * 0.7,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 20),
              height: 120,
              child: AutoSizeText(
                announcement.description,
                minFontSize: 11,
                maxFontSize: 14,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
