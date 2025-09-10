// To parse this JSON data, do
//
//     final productsOfEventResponseModel = productsOfEventResponseModelFromJson(jsonString);

import 'dart:convert';

List<ProductsOfEventResponseModel> productsOfEventResponseModelFromJson(List<dynamic> data) => List<ProductsOfEventResponseModel>.from(data.map((x) => ProductsOfEventResponseModel.fromJson(x)));

String productsOfEventResponseModelToJson(List<ProductsOfEventResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsOfEventResponseModel {
  int? id;
  String? image;

  ProductsOfEventResponseModel({
    this.id,
    this.image,
  });

  ProductsOfEventResponseModel copyWith({
    int? id,
    String? image,
  }) =>
      ProductsOfEventResponseModel(
        id: id ?? this.id,
        image: image ?? this.image,
      );

  factory ProductsOfEventResponseModel.fromJson(Map<String, dynamic> json) => ProductsOfEventResponseModel(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}
