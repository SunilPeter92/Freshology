import 'dart:convert';

import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/Announcement.dart';
import 'package:freshology/models/AdBanner.dart';
import 'package:freshology/models/slides.dart';
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

Future<List<AdBanner>> getAdBanners() async {
  List<AdBanner> _banners = [];
  final url = "${baseURL}get_banner";
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = Helper.getData(json.decode(response.body));
      for (int i = 0; i < data.length; i++) {
        _banners.add(AdBanner.fromJson(data[i]));
      }
      return _banners;
    }
  } catch (e) {
    print("ERROR! ${e}");
    return [];
  }
}

Future<Stream<Slide>> getSlides() async {
  final String url = '${baseURL}slides';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Slide.fromJson(data));
}
