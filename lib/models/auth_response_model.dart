// To parse this JSON data, do
//
//     final authResponseModel = authResponseModelFromJson(jsonString);

import 'dart:convert';

AuthResponseModel authResponseModelFromJson(String str) => AuthResponseModel.fromJson(json.decode(str));

String authResponseModelToJson(AuthResponseModel data) => json.encode(data.toJson());

class AuthResponseModel {
    User? user;
    String? accessToken;
    String? refreshToken;

    AuthResponseModel({
        this.user,
        this.accessToken,
        this.refreshToken,
    });

    AuthResponseModel copyWith({
        User? user,
        String? accessToken,
        String? refreshToken,
    }) => 
        AuthResponseModel(
            user: user ?? this.user,
            accessToken: accessToken ?? this.accessToken,
            refreshToken: refreshToken ?? this.refreshToken,
        );

    factory AuthResponseModel.fromJson(Map<String, dynamic> json) => AuthResponseModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
    };
}

class User {
    int? id;
    bool? isAdmin;
    String? fullName;
    String? userName;
    String? email;
    String? phone;

    User({
        this.id,
        this.isAdmin,
        this.fullName,
        this.userName,
        this.email,
        this.phone,
    });

    User copyWith({
        int? id,
        bool? isAdmin,
        String? fullName,
        String? userName,
        String? email,
        String? phone,
    }) => 
        User(
            id: id ?? this.id,
            isAdmin: isAdmin ?? this.isAdmin,
            fullName: fullName ?? this.fullName,
            userName: userName ?? this.userName,
            email: email ?? this.email,
            phone: phone ?? this.phone,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        isAdmin: json["isAdmin"],
        fullName: json["fullName"],
        userName: json["userName"],
        email: json["email"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "isAdmin": isAdmin,
        "fullName": fullName,
        "userName": userName,
        "email": email,
        "phone": phone,
    };
}
