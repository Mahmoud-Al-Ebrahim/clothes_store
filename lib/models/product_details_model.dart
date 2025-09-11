// To parse this JSON data, do
//
//     final productDetailsModel = productDetailsModelFromJson(jsonString);

import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) => ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) => json.encode(data.toJson());

class ProductDetailsModel {
  int? id;
  String? type;
  String? description;
  double? orginalPrice;
  String? name;
  String? styleCloth;
  double? discountedPrice;
  int? rating;
  String? discount;
  String? imageUrl;
  DateTime? discountEndDate;
  List<String>? colors;
  List<String>? sizes;
  List<String>? comments;
  int? quantity;

  ProductDetailsModel({
    this.id,
    this.type,
    this.description,
    this.orginalPrice,
    this.name,
    this.styleCloth,
    this.discountedPrice,
    this.rating,
    this.discount,
    this.imageUrl,
    this.discountEndDate,
    this.colors,
    this.sizes,
    this.comments,
    this.quantity,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
    id: json["id"],
    type: json["type"],
    description: json["description"],
    orginalPrice: json["orginalPrice"],
    name: json["name"],
    styleCloth: json["styleCloth"],
    discountedPrice: json["discountedPrice"],
    rating: json["rating"],
    discount: json["discount"],
    imageUrl: json["imageUrl"],
    discountEndDate: json["discountEndDate"] == null ? null : DateTime.parse(json["discountEndDate"]),
    colors: json["colors"] == null ? [] : List<String>.from(json["colors"]!.map((x) => x)),
    sizes: json["sizes"] == null ? [] : List<String>.from(json["sizes"]!.map((x) => x)),
    comments: json["comments"] == null ? [] : List<String>.from(json["comments"]!.map((x) => x)),
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "description": description,
    "orginalPrice": orginalPrice,
    "name": name,
    "styleCloth": styleCloth,
    "discountedPrice": discountedPrice,
    "rating": rating,
    "discount": discount,
    "imageUrl": imageUrl,
    "discountEndDate": discountEndDate?.toIso8601String(),
    "colors": colors == null ? [] : List<dynamic>.from(colors!.map((x) => x)),
    "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x)),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
    "quantity": quantity,
  };
}
