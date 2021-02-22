import 'dart:convert';

import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/Announcement.dart';
import 'package:http/http.dart' as http;

Future<Announcement> getAnnouncement() async {
  final url = "${baseURL}get_announcement";
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = Helper.getData(json.decode(response.body));

      Announcement _announcement = Announcement.fromJson(data[0]);

      return _announcement;
    }
  } catch (e) {
    print("ERROR! ${e}");
  }
}
