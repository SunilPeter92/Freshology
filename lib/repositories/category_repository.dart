import 'package:freshology/constants/Helper.dart';
import 'package:freshology/constants/configurations.dart';
import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<MainCategory>> getMainCategory() async {
  List<MainCategory> mainCategories = [];
  final url = "${baseURL}main_category";
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
        print("MAIN CATEGORY: ${e.toString()}");
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
  final url = "${baseURL}get_categories/${id}";
  print("SUB CATEGORY URL: ${url}");
  try {
    var response = await http.get(url, headers: header);
    if (response.statusCode == 202 || response.statusCode == 200) {
      var data = json.decode(response.body);
      print("SUB CATEGORY DATE: ${data}");
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
