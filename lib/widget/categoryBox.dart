import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final String imagePath;
  final String name;
  CategoryBox({@required this.imagePath, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft:
                        name == null ? Radius.circular(10) : Radius.circular(0),
                    bottomRight:
                        name == null ? Radius.circular(10) : Radius.circular(0),
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
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        name,
                        maxLines: 1,
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
