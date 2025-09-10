// To parse this JSON data, do
//
//     final productsResponseModel = productsResponseModelFromJson(jsonString);

import 'dart:convert';

List<ProductsResponseModel> productsResponseModelFromJson(List<dynamic> data) => List<ProductsResponseModel>.from(data.map((x) => ProductsResponseModel.fromJson(x)));

String productsResponseModelToJson(List<ProductsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductsResponseModel {
  int? id;
  String? type;
  String? name;
  String? description;
  double? price;
  int? rating;
  String? imageUrl;
  String? categoryName;
  double? discountPercentage;

  ProductsResponseModel({
    this.id,
    this.type,
    this.name,
    this.description,
    this.price,
    this.rating,
    this.imageUrl,
    this.categoryName,
    this.discountPercentage,
  });

  ProductsResponseModel copyWith({
    int? id,
    String? type,
    String? name,
    String? description,
    double? price,
    int? rating,
    String? imageUrl,
    String? categoryName,
    double? discountPercentage,
  }) =>
      ProductsResponseModel(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        rating: rating ?? this.rating,
        imageUrl: imageUrl ?? this.imageUrl,
        categoryName: categoryName ?? this.categoryName,
        discountPercentage: discountPercentage ?? this.discountPercentage,
      );

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) => ProductsResponseModel(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    rating: json["rating"],
    imageUrl: json["imageUrl"],
    categoryName: json["categoryName"],
    discountPercentage: json["discountPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "description": description,
    "price": price,
    "rating": rating,
    "imageUrl": imageUrl,
    "categoryName": categoryName,
    "discountPercentage": discountPercentage,
  };
}

