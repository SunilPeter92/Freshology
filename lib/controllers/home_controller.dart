// import 'package:freshology/functions/invoice.dart';
import 'package:freshology/models/Announcement.dart';
import 'package:freshology/models/category.dart';
import 'package:freshology/models/mainCategory.dart';
import 'package:freshology/models/product.dart';
import 'package:freshology/models/subCategory.dart';
import 'package:freshology/repositories/banner_repository.dart';
import 'package:freshology/repositories/category_repository.dart';
import 'package:freshology/repositories/product_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomeController extends ControllerMVC {
  Product product = Product();
  List<Category> categories = [];
  Announcement announcement = Announcement();
  bool showAnnouncement = false;
  void fetchSingleProduct(String idRestaurant) async {
    final prod = await getSingleProductId("1");
    if (prod != null) {
      product = prod;
      setState(() {});
    } else {
      // TODO: handle else //
    }
  }

  void fetchMainCategories() async {
    final _mainCategory = await getMainCategory();
    if (categories != null) {
      // categories.add(Category(mainCategory: _categories));
      for (int i = 0; i < _mainCategory.length; i++) {
        try {
          var _subCategories =
              await getSubCategory(_mainCategory[i].id.toString());
          if (_subCategories != null) {
            categories.add(
              Category(
                mainCategory: _mainCategory[i],
                subCategory: _subCategories,
              ),
            );
          }
        } catch (e) {}
      }
      // _mainCategory.forEach((mainCategory) {
      //   // categories.add(
      //   final _subCategories = await getSubCategory(categoryId.toString());
      //   //     Category(mainCategory: mainCategory, subCategory: <SubCategory>[]));
      // });
      setState(() {});
    } else {
      // TODO: handle else //
    }
  }

  void requestForSubCategories(String categoryId) async {
    final _subCategories = await getSubCategory(categoryId.toString());
    if (_subCategories != null) {
      // Category category = categories.firstWhere(
      //     (_category) => _category.mainCategory.id.toString() == categoryId);
      // category.subCategory = _subCategories;
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].mainCategory.id.toString() == categoryId.toString()) {
          categories[i].subCategory = _subCategories;
        }
      }

      setState(() {});
    } else {}
  }

  void fetchAnnouncement() async {
    final resp = await getAnnouncement();
    if (resp != null) {
      announcement = resp;
      showAnnouncement = true;
      setState(() {});
    } else {
      // TODO: handle else //
    }
  }
}
