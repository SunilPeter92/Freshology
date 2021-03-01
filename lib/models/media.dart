import '../helpers/custom_trace.dart';

class Media {
  String id;
  String name;
  String url;
  String thumb;
  String icon;
  String size;

  Media() {
    url =
        "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png";
    thumb =
        "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png";
    icon =
        "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png";
  }

  Media.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      url = jsonMap['url'];
      thumb = jsonMap['thumb'];
      icon = jsonMap['icon'];
      size = jsonMap['formated_size'];
    } catch (e) {
      url =
          "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png";
      thumb =
          "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png";
      icon =
          "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png";
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["thumb"] = thumb;
    map["icon"] = icon;
    map["formated_size"] = size;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
