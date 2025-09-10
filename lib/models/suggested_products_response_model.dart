// To parse this JSON data, do
//
//     final suggestedProductsResponseModel = suggestedProductsResponseModelFromJson(jsonString);

import 'dart:convert';

List<SuggestedProductsResponseModel> suggestedProductsResponseModelFromJson(List<dynamic> data) => List<SuggestedProductsResponseModel>.from(data.map((x) => SuggestedProductsResponseModel.fromJson(x)));

String suggestedProductsResponseModelToJson(List<SuggestedProductsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuggestedProductsResponseModel {
  int? id;
  String? color;
  String? name;
  String? size;
  int? productId;
  String? image;
  String? style;
  String? type;
  double? price;

  SuggestedProductsResponseModel({
    this.id,
    this.color,
    this.name,
    this.size,
    this.productId,
    this.image,
    this.style,
    this.type,
    this.price,
  });

  SuggestedProductsResponseModel copyWith({
    int? id,
    String? color,
    String? name,
    String? size,
    int? productId,
    String? image,
    String? style,
    String? type,
    double? price,
  }) =>
      SuggestedProductsResponseModel(
        id: id ?? this.id,
        color: color ?? this.color,
        size: size ?? this.size,
        name: name ?? this.name,
        productId: productId ?? this.productId,
        image: image ?? this.image,
        style: style ?? this.style,
        type: type ?? this.type,
        price: price ?? this.price,
      );

  factory SuggestedProductsResponseModel.fromJson(Map<String, dynamic> json) => SuggestedProductsResponseModel(
    id: json["id"],
    color: json["color"],
    size: json["size"],
    name: json["name"],
    productId: json["productId"],
    image: json["image"],
    style: json["style"],
    type: json["type"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "color": color,
    "size": size,
    "name": name,
    "productId": productId,
    "image": image,
    "style": style,
    "type": type,
    "price": price,
  };
}
