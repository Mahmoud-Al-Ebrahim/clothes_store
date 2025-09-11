// To parse this JSON data, do
//
//     final discountsResponseModel = discountsResponseModelFromJson(jsonString);

import 'dart:convert';

List<DiscountsResponseModel> discountsResponseModelFromJson(List<dynamic> data) => List<DiscountsResponseModel>.from(data.map((x) => DiscountsResponseModel.fromJson(x)));

String discountsResponseModelToJson(List<DiscountsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiscountsResponseModel {
  int? id;
  double? discountPercentage;
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic>? products;

  DiscountsResponseModel({
    this.id,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.products,
  });

  factory DiscountsResponseModel.fromJson(Map<String, dynamic> json) => DiscountsResponseModel(
    id: json["id"],
    discountPercentage: json["discountPercentage"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    products: json["products"] == null ? [] : List<dynamic>.from(json["products"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "discountPercentage": discountPercentage,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x)),
  };
}
