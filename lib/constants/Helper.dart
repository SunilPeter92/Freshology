import 'package:freshology/functions/invoice.dart';

class Helper {
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static lister(obj, List jsonList) {
    List _list = [];
    for (int i = 0; i < jsonList.length; i++) {
      _list.add(obj.fromJson(jsonList[i]));
    }
    print("LIST RUNTIME: ${_list[0].name}");
    return _list;
  }
}
