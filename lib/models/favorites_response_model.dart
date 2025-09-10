// To parse this JSON data, do
//
//     final favoritesResponseModel = favoritesResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:clothes_store/models/products_response_model.dart';

import '../core/model/Product.dart';

FavoritesResponseModel favoritesResponseModelFromJson(String str) => FavoritesResponseModel.fromJson(json.decode(str));

String favoritesResponseModelToJson(FavoritesResponseModel data) => json.encode(data.toJson());

class FavoritesResponseModel {
  bool? status;
  List<FavoriteItem>? favorites;

  FavoritesResponseModel({
    this.status,
    this.favorites,
  });

  FavoritesResponseModel copyWith({
    bool? status,
    List<FavoriteItem>? favorites,
  }) =>
      FavoritesResponseModel(
        status: status ?? this.status,
        favorites: favorites ?? this.favorites,
      );

  factory FavoritesResponseModel.fromJson(Map<String, dynamic> json) => FavoritesResponseModel(
    status: json["status"],
    favorites: json["data"] == null ? [] : List<FavoriteItem>.from(json["data"]!.map((x) => FavoriteItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": favorites == null ? [] : List<dynamic>.from(favorites!.map((x) => x.toJson())),
  };
}

class FavoriteItem {
  int? id;
  int? userId;
  int? productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? color;
  dynamic size;
  double? quantity;
  Product? product;

  FavoriteItem({
    this.id,
    this.userId,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.color,
    this.size,
    this.quantity,
    this.product,
  });

  FavoriteItem copyWith({
    int? id,
    int? userId,
    int? productId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? color,
    dynamic size,
    double? quantity,
    Product? product,
  }) =>
      FavoriteItem(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        color: color ?? this.color,
        size: size ?? this.size,
        quantity: quantity ?? this.quantity,
        product: product ?? this.product,
      );

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    color: json["color"],
    size: json["size"],
    quantity: json["quantity"] is double ? json["quantity"] : json["quantity"].toDouble(),
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "color": color,
    "size": size,
    "quantity": quantity,
  };
}

