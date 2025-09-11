// To parse this JSON data, do
//
//     final getCartResponseModel = getCartResponseModelFromJson(jsonString);

import 'dart:convert';

List<GetCartResponseModel> getCartResponseModelFromJson(List<dynamic> data) => List<GetCartResponseModel>.from(data.map((x) => GetCartResponseModel.fromJson(x)));

String getCartResponseModelToJson(List<GetCartResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCartResponseModel {
  int? productId;
  String? productType;
  String? productImage;
  String? productName;
  double? productPrice;
  int? productQuantity;

  GetCartResponseModel({
    this.productId,
    this.productType,
    this.productImage,
    this.productName,
    this.productPrice,
    this.productQuantity,
  });

  GetCartResponseModel copyWith({
    int? productId,
    String? productType,
    String? productName,
    String? productImage,
    double? productPrice,
    int? productQuantity,
  }) =>
      GetCartResponseModel(
        productId: productId ?? this.productId,
        productType: productType ?? this.productType,
        productName: productName ?? this.productName,
        productImage: productImage ?? this.productImage,
        productPrice: productPrice ?? this.productPrice,
        productQuantity: productQuantity ?? this.productQuantity,
      );

  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) => GetCartResponseModel(
    productId: json["productId"],
    productType: json["productType"],
    productName: json["name"],
    productImage: json["productImage"],
    productPrice: json["productPrice"],
    productQuantity: json["productQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productType": productType,
    "name": productName,
    "productImage": productImage,
    "productPrice": productPrice,
    "productQuantity": productQuantity,
  };
}
