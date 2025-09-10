// To parse this JSON data, do
//
//     final ordersResponseModel = ordersResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:clothes_store/models/products_response_model.dart';

import '../core/model/Product.dart';

OrdersResponseModel ordersResponseModelFromJson(String str) =>
    OrdersResponseModel.fromJson(json.decode(str));

String ordersResponseModelToJson(OrdersResponseModel data) =>
    json.encode(data.toJson());

class OrdersResponseModel {
  bool? success;
  List<OrderItem>? orders;

  OrdersResponseModel({
    this.success,
    this.orders,
  });

  OrdersResponseModel copyWith({
    bool? success,
    List<OrderItem>? orders,
  }) =>
      OrdersResponseModel(
        success: success ?? this.success,
        orders: orders ?? this.orders,
      );

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      OrdersResponseModel(
        success: json["success"],
        orders: json["data"] == null
            ? []
            : List<OrderItem>.from(
                json["data"]!.map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class OrderItem {
  int? id;
  int? userId;
  String? fullName;
  String? phoneNumber;
  String? shippingCo;
  String? shippingState;
  String? shippingBranch;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<OrderDetail>? orderDetails;

  OrderItem({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.shippingCo,
    this.shippingState,
    this.shippingBranch,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderDetails,
  });

  OrderItem copyWith({
    int? id,
    int? userId,
    String? fullName,
    String? phoneNumber,
    String? shippingCo,
    String? shippingState,
    String? shippingBranch,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderDetail>? orderDetails,
  }) =>
      OrderItem(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        shippingCo: shippingCo ?? this.shippingCo,
        shippingState: shippingState ?? this.shippingState,
        shippingBranch: shippingBranch ?? this.shippingBranch,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        orderDetails: orderDetails ?? this.orderDetails,
      );

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        userId: json["user_id"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        shippingCo: json["shipping_co"],
        shippingState: json["shipping_state"],
        shippingBranch: json["shipping_branch"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        orderDetails: json["order_details"] == null
            ? []
            : List<OrderDetail>.from(
                json["order_details"]!.map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "shipping_co": shippingCo,
        "shipping_state": shippingState,
        "shipping_branch": shippingBranch,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "order_details": orderDetails == null
            ? []
            : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
      };
}

class OrderDetail {
  int? id;
  int? orderId;
  int? productId;
  double? quantity;
  double? unitPrice;
  String? itemDetails;
  DateTime? createdAt;
  DateTime? updatedAt;
  Product? product;

  OrderDetail({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.unitPrice,
    this.itemDetails,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  OrderDetail copyWith({
    int? id,
    int? orderId,
    int? productId,
    double? quantity,
    double? unitPrice,
    String? itemDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    Product? product,
  }) =>
      OrderDetail(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        itemDetails: itemDetails ?? this.itemDetails,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        product: product ?? this.product,
      );

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        quantity: json["quantity"] is double ? json["quantity"] : json["quantity"].toDouble(),
        unitPrice: json["unit_price"] is double ? json["unit_price"] : json["unit_price"].toDouble(),
        itemDetails: json["item_details"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "product_id": productId,
        "quantity": quantity,
        "unit_price": unitPrice,
        "item_details": itemDetails,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

