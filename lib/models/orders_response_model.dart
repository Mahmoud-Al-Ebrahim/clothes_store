// To parse this JSON data, do
//
//     final ordersResponseModel = ordersResponseModelFromJson(jsonString);

import 'dart:convert';

List<OrdersResponseModel> ordersResponseModelFromJson(List<dynamic> data) => List<OrdersResponseModel>.from(data.map((x) => OrdersResponseModel.fromJson(x)));

String ordersResponseModelToJson(List<OrdersResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdersResponseModel {
  int? id;
  double? totalPrice;
  DateTime? createAt;
  String? shippingAddress;
  List<Item>? items;

  OrdersResponseModel({
    this.id,
    this.totalPrice,
    this.createAt,
    this.shippingAddress,
    this.items,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) => OrdersResponseModel(
    id: json["id"],
    totalPrice: json["totalPrice"],
    createAt: json["createAt"] == null ? null : DateTime.parse(json["createAt"]),
    shippingAddress: json["shippingAddress"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "totalPrice": totalPrice,
    "createAt": createAt?.toIso8601String(),
    "shippingAddress": shippingAddress,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  int? id;
  int? productId;
  String? productName;
  int? quantity;
  double? price;
  String? size;
  String? color;
  String? imageUrl;
  double? discountedPrice;

  Item({
    this.id,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.size,
    this.color,
    this.imageUrl,
    this.discountedPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    productId: json["productId"],
    productName: json["productName"],
    quantity: json["quantity"],
    price: json["price"],
    size: json["size"],
    color: json["color"],
    imageUrl: json["imageUrl"],
    discountedPrice: json["discountedPrice"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productId": productId,
    "productName": productName,
    "quantity": quantity,
    "price": price,
    "size": size,
    "color": color,
    "imageUrl": imageUrl,
    "discountedPrice": discountedPrice,
  };
}
