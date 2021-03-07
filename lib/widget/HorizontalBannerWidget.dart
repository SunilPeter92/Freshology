import 'package:flutter/material.dart';
import 'package:freshology/models/AdBanner.dart';

class HorizontalBannerWidget extends StatelessWidget {
  List<AdBanner> bannerList;
  HorizontalBannerWidget({@required this.bannerList});
  @override
  _buildBanners() {
    List<Widget> _widgets = [];
    for (var item in bannerList) {
      _widgets.add(
        Container(
          margin: EdgeInsets.all(5),
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.network(item.bData == null
                      ? "https://static.wikia.nocookie.net/avatar/images/3/3d/Meal.png/revision/latest?cb=20140421100424"
                      : item.bData)
                  .image,
              fit: BoxFit.fill,
            ),
          ),
          // child: Image.network("")
        ),
      );
    }
    return _widgets;
  }

  Widget build(BuildContext context) {
    return Column(
      children: _buildBanners(),
    );
  }
}
