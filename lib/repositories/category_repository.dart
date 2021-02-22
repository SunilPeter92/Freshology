import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<MainCategory>> getMainCategory() async {
  List<MainCategory> mainCategories = [];
  final url = "${baseURL}get_cate";
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = Helper.getData(
        json.decode(response.body),
      );
      try {
        for (var cate in data) {
          mainCategories.add(MainCategory.fromJson(cate));
        }
        return mainCategories;
      } catch (e) {
        return null;
      }
    }
  } catch (e) {
    print("ERROR! ${e}");
    return null;
  }
}

Future<List<SubCategory>> getSubCategory(String id) async {
  List<SubCategory> subCategories = [];
  final url = "${baseURL}get_sub_cate/${id}";
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = Helper.getData(
        json.decode(response.body),
      );
      try {
        for (var subCate in data) {
          subCategories.add(SubCategory.fromJson(subCate));
        }
        return subCategories;
      } catch (e) {
        return null;
      }
    }
  } catch (e) {
    print("ERROR! ${e}");
    return null;
  }
}
