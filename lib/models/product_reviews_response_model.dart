// To parse this JSON data, do
//
//     final productReviewsResponseModel = productReviewsResponseModelFromJson(jsonString);

import 'dart:convert';

List<ProductReviewsResponseModel> productReviewsResponseModelFromJson(List<dynamic> data) => List<ProductReviewsResponseModel>.from(data.map((x) => ProductReviewsResponseModel.fromJson(x)));

String productReviewsResponseModelToJson(List<ProductReviewsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductReviewsResponseModel {
  int? id;
  String? text;
  String? userName;
  DateTime? createdDate;

  ProductReviewsResponseModel({
    this.id,
    this.text,
    this.userName,
    this.createdDate,
  });

  ProductReviewsResponseModel copyWith({
    int? id,
    String? text,
    String? userName,
    DateTime? createdDate,
  }) =>
      ProductReviewsResponseModel(
        id: id ?? this.id,
        text: text ?? this.text,
        userName: userName ?? this.userName,
        createdDate: createdDate ?? this.createdDate,
      );

  factory ProductReviewsResponseModel.fromJson(Map<String, dynamic> json) => ProductReviewsResponseModel(
    id: json["id"],
    text: json["text"],
    userName: json["userName"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "userName": userName,
    "createdDate": createdDate?.toIso8601String(),
  };
}
