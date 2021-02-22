import 'package:flutter/material.dart';

class ProductBox extends StatelessWidget {
  final String imagePath;
  final String name;
  ProductBox({@required this.imagePath, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft:
                        name == null ? Radius.circular(0) : Radius.circular(0),
                    bottomRight:
                        name == null ? Radius.circular(0) : Radius.circular(0),
                  ),
                  child: Image(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            name != null
                ? Container(
                    // height: 40,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
