import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.pName,
    this.description,
    this.pImage,
    this.cateId,
    this.sGst,
    this.cGst,
    this.iGst,
    this.sku,
    this.hSn,
    this.defaultPriceIndex,
    this.inStock,
    this.deliveryDate,
    this.quantity,
    this.status,
    this.uId,
    this.variations,
  });

  int id;
  String pName;
  String description;
  String pImage;
  String cateId;
  String sGst;
  String cGst;
  String iGst;
  String sku;
  String hSn;
  String defaultPriceIndex;
  String inStock;
  DateTime deliveryDate;
  String quantity;
  int status;
  String uId;
  List<Variation> variations;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        pName: json["p_name"],
        description: json["description"],
        pImage: json["p_image"],
        cateId: json["cate_id"],
        sGst: json["sGST"],
        cGst: json["cGST"],
        iGst: json["iGST"],
        sku: json["sku"],
        hSn: json["hSN"],
        defaultPriceIndex: json["defaultPriceIndex"],
        inStock: json["inStock"],
        deliveryDate: DateTime.tryParse(json["deliveryDate"]),
        quantity: json["quantity"],
        status: json["status"],
        uId: json["uId"],
        variations: List<Variation>.from(
            json["variations"].map((x) => Variation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "p_name": pName,
        "description": description,
        "p_image": pImage,
        "cate_id": cateId,
        "sGST": sGst,
        "cGST": cGst,
        "iGST": iGst,
        "sku": sku,
        "hSN": hSn,
        "defaultPriceIndex": defaultPriceIndex,
        "inStock": inStock,
        "deliveryDate":
            "${deliveryDate.year.toString().padLeft(4, '0')}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}",
        "quantity": quantity,
        "status": status,
        "uId": uId,
        "variations": List<dynamic>.from(variations.map((x) => x.toJson())),
      };
}

class Variation {
  Variation({
    this.id,
    this.pId,
    this.vName,
    this.vPrice,
    this.vDiscount,
    this.status,
  });

  int id;
  String pId;
  String vName;
  String vPrice;
  String vDiscount;
  int status;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        id: json["id"],
        pId: json["p_id"],
        vName: json["v_name"],
        vPrice: json["v_price"],
        vDiscount: json["v_discount"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "p_id": pId,
        "v_name": vName,
        "v_price": vPrice,
        "v_discount": vDiscount,
        "status": status,
      };
}
