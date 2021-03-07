// // To parse this JSON data, do
// //
// //     final product = productFromJson(jsonString);

// import 'dart:convert';

// import 'package:freshology/models/extra.dart';
// import 'package:freshology/models/extra_group.dart';

// Product productFromJson(String str) => Product.fromJson(json.decode(str));

// String productToJson(Product data) => json.encode(data.toJson());

// class Product {
//   Product({
//     this.id,
//     this.name,
//     this.price,
//     this.discountPrice,
//     this.description,
//     this.ingredients,
//     this.packageItemsCount,
//     this.weight,
//     this.unit,
//     this.featured,
//     this.deliverable,
//     this.restaurantId,
//     this.categoryId,
//     this.createdAt,
//     this.updatedAt,
//     this.customFields,
//     this.hasMedia,
//     this.restaurant,
//     this.media,
//     this.extraGroups,
//     this.extras,
//   });

//   int id;
//   String name;
//   double price;
//   int discountPrice;
//   String description;
//   dynamic ingredients;
//   int packageItemsCount;
//   double weight;
//   String unit;
//   bool featured;
//   bool deliverable;
//   int restaurantId;
//   int categoryId;
//   String createdAt;
//   String updatedAt;
//   List<Extra> extras;
//   List<ExtraGroup> extraGroups;
//   List<dynamic> customFields;
//   bool hasMedia;
//   Restaurant restaurant;
//   List<Media> media;

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         price: json["price"] == null ? null : json["price"].toDouble(),
//         discountPrice:
//             json["discount_price"] == null ? null : json["discount_price"],
//         description: json["description"] == null ? null : json["description"],
//         ingredients: json["ingredients"],
//         packageItemsCount: json["package_items_count"] == null
//             ? null
//             : json["package_items_count"],
//         weight: json["weight"] == null ? null : json["weight"].toDouble(),
//         unit: json["unit"] == null ? null : json["unit"],
//         featured: json["featured"] == null ? null : json["featured"],
//         deliverable: json["deliverable"] == null ? null : json["deliverable"],
//         restaurantId:
//             json["restaurant_id"] == null ? null : json["restaurant_id"],
//         categoryId: json["category_id"] == null ? null : json["category_id"],
//         extras: json['extras'] != null && (json['extras'] as List).length > 0
//             ? List.from(json['extras'])
//                 .map((element) => Extra.fromJSON(element))
//                 .toSet()
//                 .toList()
//             : [],
//         extraGroups: json['extra_groups'] != null &&
//                 (json['extra_groups'] as List).length > 0
//             ? List.from(json['extra_groups'])
//                 .map((element) => ExtraGroup.fromJSON(element))
//                 .toSet()
//                 .toList()
//             : [],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         customFields: json["custom_fields"] == null
//             ? null
//             : List<dynamic>.from(json["custom_fields"].map((x) => x)),
//         hasMedia: json["has_media"] == null ? null : json["has_media"],
//         restaurant: json["restaurant"] == null
//             ? null
//             : Restaurant.fromJson(json["restaurant"]),
//         media: json["media"] == null
//             ? null
//             : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "price": price == null ? null : price,
//         "discount_price": discountPrice == null ? null : discountPrice,
//         "description": description == null ? null : description,
//         "ingredients": ingredients,
//         "package_items_count":
//             packageItemsCount == null ? null : packageItemsCount,
//         "weight": weight == null ? null : weight,
//         "unit": unit == null ? null : unit,
//         "featured": featured == null ? null : featured,
//         "deliverable": deliverable == null ? null : deliverable,
//         "restaurant_id": restaurantId == null ? null : restaurantId,
//         "category_id": categoryId == null ? null : categoryId,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "custom_fields": customFields == null
//             ? null
//             : List<dynamic>.from(customFields.map((x) => x)),
//         "has_media": hasMedia == null ? null : hasMedia,
//         "restaurant": restaurant == null ? null : restaurant.toJson(),
//         "media": media == null
//             ? null
//             : List<dynamic>.from(media.map((x) => x.toJson())),
//       };
// }

// class Media {
//   Media({
//     this.id,
//     this.modelType,
//     this.modelId,
//     this.collectionName,
//     this.name,
//     this.fileName,
//     this.mimeType,
//     this.disk,
//     this.size,
//     this.manipulations,
//     this.customProperties,
//     this.responsiveImages,
//     this.orderColumn,
//     this.createdAt,
//     this.updatedAt,
//     this.url,
//     this.thumb,
//     this.icon,
//     this.formatedSize,
//   });

//   int id;
//   String modelType;
//   int modelId;
//   String collectionName;
//   String name;
//   String fileName;
//   String mimeType;
//   String disk;
//   int size;
//   List<dynamic> manipulations;
//   CustomProperties customProperties;
//   List<dynamic> responsiveImages;
//   int orderColumn;
//   String createdAt;
//   String updatedAt;
//   String url;
//   String thumb;
//   String icon;
//   String formatedSize;

//   factory Media.fromJson(Map<String, dynamic> json) => Media(
//         id: json["id"] == null ? null : json["id"],
//         modelType: json["model_type"] == null ? null : json["model_type"],
//         modelId: json["model_id"] == null ? null : json["model_id"],
//         collectionName:
//             json["collection_name"] == null ? null : json["collection_name"],
//         name: json["name"] == null ? null : json["name"],
//         fileName: json["file_name"] == null ? null : json["file_name"],
//         mimeType: json["mime_type"] == null ? null : json["mime_type"],
//         disk: json["disk"] == null ? null : json["disk"],
//         size: json["size"] == null ? null : json["size"],
//         manipulations: json["manipulations"] == null
//             ? null
//             : List<dynamic>.from(json["manipulations"].map((x) => x)),
//         customProperties: json["custom_properties"] == null
//             ? null
//             : CustomProperties.fromJson(json["custom_properties"]),
//         responsiveImages: json["responsive_images"] == null
//             ? null
//             : List<dynamic>.from(json["responsive_images"].map((x) => x)),
//         orderColumn: json["order_column"] == null ? null : json["order_column"],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         url: json["url"] == null ? null : json["url"],
//         thumb: json["thumb"] == null ? null : json["thumb"],
//         icon: json["icon"] == null ? null : json["icon"],
//         formatedSize:
//             json["formated_size"] == null ? null : json["formated_size"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "model_type": modelType == null ? null : modelType,
//         "model_id": modelId == null ? null : modelId,
//         "collection_name": collectionName == null ? null : collectionName,
//         "name": name == null ? null : name,
//         "file_name": fileName == null ? null : fileName,
//         "mime_type": mimeType == null ? null : mimeType,
//         "disk": disk == null ? null : disk,
//         "size": size == null ? null : size,
//         "manipulations": manipulations == null
//             ? null
//             : List<dynamic>.from(manipulations.map((x) => x)),
//         "custom_properties":
//             customProperties == null ? null : customProperties.toJson(),
//         "responsive_images": responsiveImages == null
//             ? null
//             : List<dynamic>.from(responsiveImages.map((x) => x)),
//         "order_column": orderColumn == null ? null : orderColumn,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "url": url == null ? null : url,
//         "thumb": thumb == null ? null : thumb,
//         "icon": icon == null ? null : icon,
//         "formated_size": formatedSize == null ? null : formatedSize,
//       };
// }

// class CustomProperties {
//   CustomProperties({
//     this.uuid,
//     this.userId,
//     this.generatedConversions,
//   });

//   String uuid;
//   int userId;
//   GeneratedConversions generatedConversions;

//   factory CustomProperties.fromJson(Map<String, dynamic> json) =>
//       CustomProperties(
//         uuid: json["uuid"] == null ? null : json["uuid"],
//         userId: json["user_id"] == null ? null : json["user_id"],
//         generatedConversions: json["generated_conversions"] == null
//             ? null
//             : GeneratedConversions.fromJson(json["generated_conversions"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "uuid": uuid == null ? null : uuid,
//         "user_id": userId == null ? null : userId,
//         "generated_conversions":
//             generatedConversions == null ? null : generatedConversions.toJson(),
//       };
// }

// class GeneratedConversions {
//   GeneratedConversions({
//     this.thumb,
//     this.icon,
//   });

//   bool thumb;
//   bool icon;

//   factory GeneratedConversions.fromJson(Map<String, dynamic> json) =>
//       GeneratedConversions(
//         thumb: json["thumb"] == null ? null : json["thumb"],
//         icon: json["icon"] == null ? null : json["icon"],
//       );

//   Map<String, dynamic> toJson() => {
//         "thumb": thumb == null ? null : thumb,
//         "icon": icon == null ? null : icon,
//       };
// }

// class Restaurant {
//   Restaurant({
//     this.id,
//     this.name,
//     this.description,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.phone,
//     this.mobile,
//     this.information,
//     this.adminCommission,
//     this.deliveryFee,
//     this.deliveryRange,
//     this.defaultTax,
//     this.closed,
//     this.active,
//     this.availableForDelivery,
//     this.createdAt,
//     this.updatedAt,
//     this.type,
//     this.customFields,
//     this.hasMedia,
//     this.rate,
//     this.media,
//   });

//   int id;
//   String name;
//   String description;
//   String address;
//   String latitude;
//   String longitude;
//   String phone;
//   String mobile;
//   String information;
//   double adminCommission;
//   double deliveryFee;
//   double deliveryRange;
//   double defaultTax;
//   bool closed;
//   bool active;
//   bool availableForDelivery;
//   String createdAt;
//   String updatedAt;
//   String type;
//   List<dynamic> customFields;
//   bool hasMedia;
//   String rate;
//   List<dynamic> media;

//   factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         description: json["description"] == null ? null : json["description"],
//         address: json["address"] == null ? null : json["address"],
//         latitude: json["latitude"] == null ? null : json["latitude"],
//         longitude: json["longitude"] == null ? null : json["longitude"],
//         phone: json["phone"] == null ? null : json["phone"],
//         mobile: json["mobile"] == null ? null : json["mobile"],
//         information: json["information"] == null ? null : json["information"],
//         adminCommission: json["admin_commission"] == null
//             ? null
//             : json["admin_commission"].toDouble(),
//         deliveryFee: json["delivery_fee"] == null
//             ? null
//             : json["delivery_fee"].toDouble(),
//         deliveryRange: json["delivery_range"] == null
//             ? null
//             : json["delivery_range"].toDouble(),
//         defaultTax:
//             json["default_tax"] == null ? null : json["default_tax"].toDouble(),
//         closed: json["closed"] == null ? null : json["closed"],
//         active: json["active"] == null ? null : json["active"],
//         availableForDelivery: json["available_for_delivery"] == null
//             ? null
//             : json["available_for_delivery"],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         type: json["type"] == null ? null : json["type"],
//         customFields: json["custom_fields"] == null
//             ? null
//             : List<dynamic>.from(json["custom_fields"].map((x) => x)),
//         hasMedia: json["has_media"] == null ? null : json["has_media"],
//         rate: json["rate"] == null ? null : json["rate"],
//         media: json["media"] == null
//             ? null
//             : List<dynamic>.from(json["media"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "description": description == null ? null : description,
//         "address": address == null ? null : address,
//         "latitude": latitude == null ? null : latitude,
//         "longitude": longitude == null ? null : longitude,
//         "phone": phone == null ? null : phone,
//         "mobile": mobile == null ? null : mobile,
//         "information": information == null ? null : information,
//         "admin_commission": adminCommission == null ? null : adminCommission,
//         "delivery_fee": deliveryFee == null ? null : deliveryFee,
//         "delivery_range": deliveryRange == null ? null : deliveryRange,
//         "default_tax": defaultTax == null ? null : defaultTax,
//         "closed": closed == null ? null : closed,
//         "active": active == null ? null : active,
//         "available_for_delivery":
//             availableForDelivery == null ? null : availableForDelivery,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "type": type == null ? null : type,
//         "custom_fields": customFields == null
//             ? null
//             : List<dynamic>.from(customFields.map((x) => x)),
//         "has_media": hasMedia == null ? null : hasMedia,
//         "rate": rate == null ? null : rate,
//         "media": media == null ? null : List<dynamic>.from(media.map((x) => x)),
//       };
// }
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

// import 'dart:convert';

// Product productFromJson(String str) => Product.fromJson(json.decode(str));

// String productToJson(Product data) => json.encode(data.toJson());

// class Product {
//   Product({
//     this.id,
//     this.name,
//     this.price,
//     this.discountPrice,
//     this.description,
//     this.ingredients,
//     this.packageItemsCount,
//     this.weight,
//     this.unit,
//     this.featured,
//     this.deliverable,
//     this.restaurantId,
//     this.categoryId,
//     this.createdAt,
//     this.updatedAt,
//     this.customFields,
//     this.hasMedia,
//     this.restaurant,
//     this.extras,
//     this.media,
//   });

//   int id;
//   String name;
//   double price;
//   int discountPrice;
//   String description;
//   dynamic ingredients;
//   int packageItemsCount;
//   double weight;
//   String unit;
//   bool featured;
//   bool deliverable;
//   int restaurantId;
//   int categoryId;
//   String createdAt;
//   String updatedAt;
//   List<dynamic> customFields;
//   bool hasMedia;
//   Restaurant restaurant;
//   List<Extra> extras;
//   List<Media> media;

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         price: json["price"] == null ? null : json["price"].toDouble(),
//         discountPrice:
//             json["discount_price"] == null ? null : json["discount_price"],
//         description: json["description"] == null ? null : json["description"],
//         ingredients: json["ingredients"],
//         packageItemsCount: json["package_items_count"] == null
//             ? null
//             : json["package_items_count"],
//         weight: json["weight"] == null ? null : json["weight"].toDouble(),
//         unit: json["unit"] == null ? null : json["unit"],
//         featured: json["featured"] == null ? null : json["featured"],
//         deliverable: json["deliverable"] == null ? null : json["deliverable"],
//         restaurantId:
//             json["restaurant_id"] == null ? null : json["restaurant_id"],
//         categoryId: json["category_id"] == null ? null : json["category_id"],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         customFields: json["custom_fields"] == null
//             ? null
//             : List<dynamic>.from(json["custom_fields"].map((x) => x)),
//         hasMedia: json["has_media"] == null ? null : json["has_media"],
//         restaurant: json["restaurant"] == null
//             ? null
//             : Restaurant.fromJson(json["restaurant"]),
//         extras: json["extras"] == null
//             ? null
//             : List<Extra>.from(json["extras"].map((x) => Extra.fromJson(x))),
//         media: json["media"] == null
//             ? null
//             : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "price": price == null ? null : price,
//         "discount_price": discountPrice == null ? null : discountPrice,
//         "description": description == null ? null : description,
//         "ingredients": ingredients,
//         "package_items_count":
//             packageItemsCount == null ? null : packageItemsCount,
//         "weight": weight == null ? null : weight,
//         "unit": unit == null ? null : unit,
//         "featured": featured == null ? null : featured,
//         "deliverable": deliverable == null ? null : deliverable,
//         "restaurant_id": restaurantId == null ? null : restaurantId,
//         "category_id": categoryId == null ? null : categoryId,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "custom_fields": customFields == null
//             ? null
//             : List<dynamic>.from(customFields.map((x) => x)),
//         "has_media": hasMedia == null ? null : hasMedia,
//         "restaurant": restaurant == null ? null : restaurant.toJson(),
//         "extras": extras == null
//             ? null
//             : List<dynamic>.from(extras.map((x) => x.toJson())),
//         "media": media == null
//             ? null
//             : List<dynamic>.from(media.map((x) => x.toJson())),
//       };
// }

// class Extra {
//   Extra({
//     this.id,
//     this.name,
//     this.description,
//     this.price,
//     this.foodId,
//     this.extraGroupId,
//     this.createdAt,
//     this.updatedAt,
//     this.customFields,
//     this.hasMedia,
//     this.media,
//   });

//   int id;
//   String name;
//   dynamic description;
//   double price;
//   int foodId;
//   int extraGroupId;
//   String createdAt;
//   String updatedAt;
//   List<dynamic> customFields;
//   bool hasMedia;
//   List<dynamic> media;

//   factory Extra.fromJson(Map<String, dynamic> json) => Extra(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         description: json["description"],
//         price: json["price"] == null ? null : json["price"].toDouble(),
//         foodId: json["food_id"] == null ? null : json["food_id"],
//         extraGroupId:
//             json["extra_group_id"] == null ? null : json["extra_group_id"],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         customFields: json["custom_fields"] == null
//             ? null
//             : List<dynamic>.from(json["custom_fields"].map((x) => x)),
//         hasMedia: json["has_media"] == null ? null : json["has_media"],
//         media: json["media"] == null
//             ? null
//             : List<dynamic>.from(json["media"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "description": description,
//         "price": price == null ? null : price,
//         "food_id": foodId == null ? null : foodId,
//         "extra_group_id": extraGroupId == null ? null : extraGroupId,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "custom_fields": customFields == null
//             ? null
//             : List<dynamic>.from(customFields.map((x) => x)),
//         "has_media": hasMedia == null ? null : hasMedia,
//         "media": media == null ? null : List<dynamic>.from(media.map((x) => x)),
//       };
// }

// class Media {
//   Media({
//     this.id,
//     this.modelType,
//     this.modelId,
//     this.collectionName,
//     this.name,
//     this.fileName,
//     this.mimeType,
//     this.disk,
//     this.size,
//     this.manipulations,
//     this.customProperties,
//     this.responsiveImages,
//     this.orderColumn,
//     this.createdAt,
//     this.updatedAt,
//     this.url,
//     this.thumb,
//     this.icon,
//     this.formatedSize,
//   });

//   int id;
//   String modelType;
//   int modelId;
//   String collectionName;
//   String name;
//   String fileName;
//   String mimeType;
//   String disk;
//   int size;
//   List<dynamic> manipulations;
//   CustomProperties customProperties;
//   List<dynamic> responsiveImages;
//   int orderColumn;
//   String createdAt;
//   String updatedAt;
//   String url;
//   String thumb;
//   String icon;
//   String formatedSize;

//   factory Media.fromJson(Map<String, dynamic> json) => Media(
//         id: json["id"] == null ? null : json["id"],
//         modelType: json["model_type"] == null ? null : json["model_type"],
//         modelId: json["model_id"] == null ? null : json["model_id"],
//         collectionName:
//             json["collection_name"] == null ? null : json["collection_name"],
//         name: json["name"] == null ? null : json["name"],
//         fileName: json["file_name"] == null ? null : json["file_name"],
//         mimeType: json["mime_type"] == null ? null : json["mime_type"],
//         disk: json["disk"] == null ? null : json["disk"],
//         size: json["size"] == null ? null : json["size"],
//         manipulations: json["manipulations"] == null
//             ? null
//             : List<dynamic>.from(json["manipulations"].map((x) => x)),
//         customProperties: json["custom_properties"] == null
//             ? null
//             : CustomProperties.fromJson(json["custom_properties"]),
//         responsiveImages: json["responsive_images"] == null
//             ? null
//             : List<dynamic>.from(json["responsive_images"].map((x) => x)),
//         orderColumn: json["order_column"] == null ? null : json["order_column"],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         url: json["url"] == null ? null : json["url"],
//         thumb: json["thumb"] == null ? null : json["thumb"],
//         icon: json["icon"] == null ? null : json["icon"],
//         formatedSize:
//             json["formated_size"] == null ? null : json["formated_size"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "model_type": modelType == null ? null : modelType,
//         "model_id": modelId == null ? null : modelId,
//         "collection_name": collectionName == null ? null : collectionName,
//         "name": name == null ? null : name,
//         "file_name": fileName == null ? null : fileName,
//         "mime_type": mimeType == null ? null : mimeType,
//         "disk": disk == null ? null : disk,
//         "size": size == null ? null : size,
//         "manipulations": manipulations == null
//             ? null
//             : List<dynamic>.from(manipulations.map((x) => x)),
//         "custom_properties":
//             customProperties == null ? null : customProperties.toJson(),
//         "responsive_images": responsiveImages == null
//             ? null
//             : List<dynamic>.from(responsiveImages.map((x) => x)),
//         "order_column": orderColumn == null ? null : orderColumn,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "url": url == null ? null : url,
//         "thumb": thumb == null ? null : thumb,
//         "icon": icon == null ? null : icon,
//         "formated_size": formatedSize == null ? null : formatedSize,
//       };
// }

// class CustomProperties {
//   CustomProperties({
//     this.uuid,
//     this.userId,
//     this.generatedConversions,
//   });

//   String uuid;
//   int userId;
//   GeneratedConversions generatedConversions;

//   factory CustomProperties.fromJson(Map<String, dynamic> json) =>
//       CustomProperties(
//         uuid: json["uuid"] == null ? null : json["uuid"],
//         userId: json["user_id"] == null ? null : json["user_id"],
//         generatedConversions: json["generated_conversions"] == null
//             ? null
//             : GeneratedConversions.fromJson(json["generated_conversions"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "uuid": uuid == null ? null : uuid,
//         "user_id": userId == null ? null : userId,
//         "generated_conversions":
//             generatedConversions == null ? null : generatedConversions.toJson(),
//       };
// }

// class GeneratedConversions {
//   GeneratedConversions({
//     this.thumb,
//     this.icon,
//   });

//   bool thumb;
//   bool icon;

//   factory GeneratedConversions.fromJson(Map<String, dynamic> json) =>
//       GeneratedConversions(
//         thumb: json["thumb"] == null ? null : json["thumb"],
//         icon: json["icon"] == null ? null : json["icon"],
//       );

//   Map<String, dynamic> toJson() => {
//         "thumb": thumb == null ? null : thumb,
//         "icon": icon == null ? null : icon,
//       };
// }

// class Restaurant {
//   Restaurant({
//     this.id,
//     this.name,
//     this.description,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.phone,
//     this.mobile,
//     this.information,
//     this.adminCommission,
//     this.deliveryFee,
//     this.deliveryRange,
//     this.defaultTax,
//     this.closed,
//     this.active,
//     this.availableForDelivery,
//     this.createdAt,
//     this.updatedAt,
//     this.type,
//     this.customFields,
//     this.hasMedia,
//     this.rate,
//     this.media,
//   });

//   int id;
//   String name;
//   String description;
//   String address;
//   String latitude;
//   String longitude;
//   String phone;
//   String mobile;
//   String information;
//   double adminCommission;
//   double deliveryFee;
//   int deliveryRange;
//   double defaultTax;
//   bool closed;
//   bool active;
//   bool availableForDelivery;
//   String createdAt;
//   String updatedAt;
//   dynamic type;
//   List<dynamic> customFields;
//   bool hasMedia;
//   String rate;
//   List<dynamic> media;

//   factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         description: json["description"] == null ? null : json["description"],
//         address: json["address"] == null ? null : json["address"],
//         latitude: json["latitude"] == null ? null : json["latitude"],
//         longitude: json["longitude"] == null ? null : json["longitude"],
//         phone: json["phone"] == null ? null : json["phone"],
//         mobile: json["mobile"] == null ? null : json["mobile"],
//         information: json["information"] == null ? null : json["information"],
//         adminCommission: json["admin_commission"] == null
//             ? null
//             : json["admin_commission"].toDouble(),
//         deliveryFee: json["delivery_fee"] == null
//             ? null
//             : json["delivery_fee"].toDouble(),
//         deliveryRange:
//             json["delivery_range"] == null ? null : json["delivery_range"],
//         defaultTax:
//             json["default_tax"] == null ? null : json["default_tax"].toDouble(),
//         closed: json["closed"] == null ? null : json["closed"],
//         active: json["active"] == null ? null : json["active"],
//         availableForDelivery: json["available_for_delivery"] == null
//             ? null
//             : json["available_for_delivery"],
//         createdAt: json["created_at"] == null ? null : json["created_at"],
//         updatedAt: json["updated_at"] == null ? null : json["updated_at"],
//         type: json["type"],
//         customFields: json["custom_fields"] == null
//             ? null
//             : List<dynamic>.from(json["custom_fields"].map((x) => x)),
//         hasMedia: json["has_media"] == null ? null : json["has_media"],
//         rate: json["rate"] == null ? null : json["rate"],
//         media: json["media"] == null
//             ? null
//             : List<dynamic>.from(json["media"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "description": description == null ? null : description,
//         "address": address == null ? null : address,
//         "latitude": latitude == null ? null : latitude,
//         "longitude": longitude == null ? null : longitude,
//         "phone": phone == null ? null : phone,
//         "mobile": mobile == null ? null : mobile,
//         "information": information == null ? null : information,
//         "admin_commission": adminCommission == null ? null : adminCommission,
//         "delivery_fee": deliveryFee == null ? null : deliveryFee,
//         "delivery_range": deliveryRange == null ? null : deliveryRange,
//         "default_tax": defaultTax == null ? null : defaultTax,
//         "closed": closed == null ? null : closed,
//         "active": active == null ? null : active,
//         "available_for_delivery":
//             availableForDelivery == null ? null : availableForDelivery,
//         "created_at": createdAt == null ? null : createdAt,
//         "updated_at": updatedAt == null ? null : updatedAt,
//         "type": type,
//         "custom_fields": customFields == null
//             ? null
//             : List<dynamic>.from(customFields.map((x) => x)),
//         "has_media": hasMedia == null ? null : hasMedia,
//         "rate": rate == null ? null : rate,
//         "media": media == null ? null : List<dynamic>.from(media.map((x) => x)),
//       };
// }
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.name,
    this.price,
    this.discountPrice,
    this.description,
    this.ingredients,
    this.packageItemsCount,
    this.weight,
    this.unit,
    this.featured,
    this.deliverable,
    this.restaurantId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.hasMedia,
    this.restaurant,
    this.extras,
    this.media,
  });

  int id;
  String name;
  double price;
  double discountPrice;
  dynamic description;
  dynamic ingredients;
  dynamic packageItemsCount;
  int weight;
  String unit;
  bool featured;
  bool deliverable;
  int restaurantId;
  int categoryId;
  String createdAt;
  String updatedAt;
  List<dynamic> customFields;
  bool hasMedia;
  Restaurant restaurant;
  List<Extra> extras;
  List<Media> media;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        discountPrice: json["discount_price"] == null
            ? null
            : json["discount_price"].toDouble(),
        description: json["description"],
        ingredients: json["ingredients"],
        packageItemsCount: json["package_items_count"],
        weight: json["weight"] == null ? null : json["weight"],
        unit: json["unit"] == null ? null : json["unit"],
        featured: json["featured"] == null ? null : json["featured"],
        deliverable: json["deliverable"] == null ? null : json["deliverable"],
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        customFields: json["custom_fields"] == null
            ? null
            : List<dynamic>.from(json["custom_fields"].map((x) => x)),
        hasMedia: json["has_media"] == null ? null : json["has_media"],
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
        extras: json["extras"] == null
            ? null
            : List<Extra>.from(json["extras"].map((x) => Extra.fromJson(x))),
        media: json["media"] == null
            ? null
            : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "discount_price": discountPrice == null ? null : discountPrice,
        "description": description,
        "ingredients": ingredients,
        "package_items_count": packageItemsCount,
        "weight": weight == null ? null : weight,
        "unit": unit == null ? null : unit,
        "featured": featured == null ? null : featured,
        "deliverable": deliverable == null ? null : deliverable,
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "category_id": categoryId == null ? null : categoryId,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "custom_fields": customFields == null
            ? null
            : List<dynamic>.from(customFields.map((x) => x)),
        "has_media": hasMedia == null ? null : hasMedia,
        "restaurant": restaurant == null ? null : restaurant.toJson(),
        "extras": extras == null
            ? null
            : List<dynamic>.from(extras.map((x) => x.toJson())),
        "media": media == null
            ? null
            : List<dynamic>.from(media.map((x) => x.toJson())),
      };
}

class Extra {
  Extra({
    this.id,
    this.name,
    this.description,
    this.price,
    this.foodId,
    this.extraGroupId,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.hasMedia,
    this.media,
  });

  int id;
  String name;
  dynamic description;
  double price;
  int foodId;
  int extraGroupId;
  String createdAt;
  String updatedAt;
  List<dynamic> customFields;
  bool hasMedia;
  List<dynamic> media;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        foodId: json["food_id"] == null ? null : json["food_id"],
        extraGroupId:
            json["extra_group_id"] == null ? null : json["extra_group_id"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        customFields: json["custom_fields"] == null
            ? null
            : List<dynamic>.from(json["custom_fields"].map((x) => x)),
        hasMedia: json["has_media"] == null ? null : json["has_media"],
        media: json["media"] == null
            ? null
            : List<dynamic>.from(json["media"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description,
        "price": price == null ? null : price,
        "food_id": foodId == null ? null : foodId,
        "extra_group_id": extraGroupId == null ? null : extraGroupId,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "custom_fields": customFields == null
            ? null
            : List<dynamic>.from(customFields.map((x) => x)),
        "has_media": hasMedia == null ? null : hasMedia,
        "media": media == null ? null : List<dynamic>.from(media.map((x) => x)),
      };
}

class Media {
  Media({
    this.id,
    this.modelType,
    this.modelId,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.thumb,
    this.icon,
    this.formatedSize,
  });

  int id;
  String modelType;
  int modelId;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  int size;
  List<dynamic> manipulations;
  CustomProperties customProperties;
  List<dynamic> responsiveImages;
  int orderColumn;
  String createdAt;
  String updatedAt;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"] == null ? null : json["id"],
        modelType: json["model_type"] == null ? null : json["model_type"],
        modelId: json["model_id"] == null ? null : json["model_id"],
        collectionName:
            json["collection_name"] == null ? null : json["collection_name"],
        name: json["name"] == null ? null : json["name"],
        fileName: json["file_name"] == null ? null : json["file_name"],
        mimeType: json["mime_type"] == null ? null : json["mime_type"],
        disk: json["disk"] == null ? null : json["disk"],
        size: json["size"] == null ? null : json["size"],
        manipulations: json["manipulations"] == null
            ? null
            : List<dynamic>.from(json["manipulations"].map((x) => x)),
        customProperties: json["custom_properties"] == null
            ? null
            : CustomProperties.fromJson(json["custom_properties"]),
        responsiveImages: json["responsive_images"] == null
            ? null
            : List<dynamic>.from(json["responsive_images"].map((x) => x)),
        orderColumn: json["order_column"] == null ? null : json["order_column"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        url: json["url"] == null ? null : json["url"],
        thumb: json["thumb"] == null ? null : json["thumb"],
        icon: json["icon"] == null ? null : json["icon"],
        formatedSize:
            json["formated_size"] == null ? null : json["formated_size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "model_type": modelType == null ? null : modelType,
        "model_id": modelId == null ? null : modelId,
        "collection_name": collectionName == null ? null : collectionName,
        "name": name == null ? null : name,
        "file_name": fileName == null ? null : fileName,
        "mime_type": mimeType == null ? null : mimeType,
        "disk": disk == null ? null : disk,
        "size": size == null ? null : size,
        "manipulations": manipulations == null
            ? null
            : List<dynamic>.from(manipulations.map((x) => x)),
        "custom_properties":
            customProperties == null ? null : customProperties.toJson(),
        "responsive_images": responsiveImages == null
            ? null
            : List<dynamic>.from(responsiveImages.map((x) => x)),
        "order_column": orderColumn == null ? null : orderColumn,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "url": url == null ? null : url,
        "thumb": thumb == null ? null : thumb,
        "icon": icon == null ? null : icon,
        "formated_size": formatedSize == null ? null : formatedSize,
      };
}

class CustomProperties {
  CustomProperties({
    this.uuid,
    this.userId,
    this.generatedConversions,
  });

  String uuid;
  int userId;
  GeneratedConversions generatedConversions;

  factory CustomProperties.fromJson(Map<String, dynamic> json) =>
      CustomProperties(
        uuid: json["uuid"] == null ? null : json["uuid"],
        userId: json["user_id"] == null ? null : json["user_id"],
        generatedConversions: json["generated_conversions"] == null
            ? null
            : GeneratedConversions.fromJson(json["generated_conversions"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid == null ? null : uuid,
        "user_id": userId == null ? null : userId,
        "generated_conversions":
            generatedConversions == null ? null : generatedConversions.toJson(),
      };
}

class GeneratedConversions {
  GeneratedConversions({
    this.thumb,
    this.icon,
  });

  bool thumb;
  bool icon;

  factory GeneratedConversions.fromJson(Map<String, dynamic> json) =>
      GeneratedConversions(
        thumb: json["thumb"] == null ? null : json["thumb"],
        icon: json["icon"] == null ? null : json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "thumb": thumb == null ? null : thumb,
        "icon": icon == null ? null : icon,
      };
}

class Restaurant {
  Restaurant({
    this.id,
    this.name,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.mobile,
    this.information,
    this.adminCommission,
    this.deliveryFee,
    this.deliveryRange,
    this.defaultTax,
    this.closed,
    this.active,
    this.availableForDelivery,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.customFields,
    this.hasMedia,
    this.rate,
    this.media,
  });

  int id;
  String name;
  String description;
  String address;
  String latitude;
  String longitude;
  String phone;
  String mobile;
  String information;
  double adminCommission;
  double deliveryFee;
  double deliveryRange;
  double defaultTax;
  bool closed;
  bool active;
  bool availableForDelivery;
  String createdAt;
  String updatedAt;
  String type;
  List<dynamic> customFields;
  bool hasMedia;
  String rate;
  List<dynamic> media;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        address: json["address"] == null ? null : json["address"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        phone: json["phone"] == null ? null : json["phone"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        information: json["information"] == null ? null : json["information"],
        adminCommission: json["admin_commission"] == null
            ? null
            : json["admin_commission"].toDouble(),
        deliveryFee: json["delivery_fee"] == null
            ? null
            : json["delivery_fee"].toDouble(),
        deliveryRange: json["delivery_range"] == null
            ? null
            : json["delivery_range"].toDouble(),
        defaultTax:
            json["default_tax"] == null ? null : json["default_tax"].toDouble(),
        closed: json["closed"] == null ? null : json["closed"],
        active: json["active"] == null ? null : json["active"],
        availableForDelivery: json["available_for_delivery"] == null
            ? null
            : json["available_for_delivery"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        updatedAt: json["updated_at"] == null ? null : json["updated_at"],
        type: json["type"] == null ? null : json["type"],
        customFields: json["custom_fields"] == null
            ? null
            : List<dynamic>.from(json["custom_fields"].map((x) => x)),
        hasMedia: json["has_media"] == null ? null : json["has_media"],
        rate: json["rate"] == null ? null : json["rate"],
        media: json["media"] == null
            ? null
            : List<dynamic>.from(json["media"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "address": address == null ? null : address,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "phone": phone == null ? null : phone,
        "mobile": mobile == null ? null : mobile,
        "information": information == null ? null : information,
        "admin_commission": adminCommission == null ? null : adminCommission,
        "delivery_fee": deliveryFee == null ? null : deliveryFee,
        "delivery_range": deliveryRange == null ? null : deliveryRange,
        "default_tax": defaultTax == null ? null : defaultTax,
        "closed": closed == null ? null : closed,
        "active": active == null ? null : active,
        "available_for_delivery":
            availableForDelivery == null ? null : availableForDelivery,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "type": type == null ? null : type,
        "custom_fields": customFields == null
            ? null
            : List<dynamic>.from(customFields.map((x) => x)),
        "has_media": hasMedia == null ? null : hasMedia,
        "rate": rate == null ? null : rate,
        "media": media == null ? null : List<dynamic>.from(media.map((x) => x)),
      };
}
