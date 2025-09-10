// To parse this JSON data, do
//
//     final categoriesResponseModel = categoriesResponseModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesResponseModel> categoriesResponseModelFromJson(List<dynamic> data) => List<CategoriesResponseModel>.from(data.map((x) => CategoriesResponseModel.fromJson(x)));

String categoriesResponseModelToJson(List<CategoriesResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesResponseModel {
  int? id;
  String? name;

  CategoriesResponseModel({
    this.id,
    this.name,
  });

  CategoriesResponseModel copyWith({
    int? id,
    String? name,
  }) =>
      CategoriesResponseModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) => CategoriesResponseModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
