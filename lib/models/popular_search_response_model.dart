// To parse this JSON data, do
//
//     final popularSearchResponseModel = popularSearchResponseModelFromJson(jsonString);

import 'dart:convert';

List<PopularSearchResponseModel> popularSearchResponseModelFromJson(List<dynamic> data) => List<PopularSearchResponseModel>.from(data.map((x) => PopularSearchResponseModel.fromJson(x)));

String popularSearchResponseModelToJson(List<PopularSearchResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularSearchResponseModel {
  String? term;
  int? count;

  PopularSearchResponseModel({
    this.term,
    this.count,
  });

  PopularSearchResponseModel copyWith({
    String? term,
    int? count,
  }) =>
      PopularSearchResponseModel(
        term: term ?? this.term,
        count: count ?? this.count,
      );

  factory PopularSearchResponseModel.fromJson(Map<String, dynamic> json) => PopularSearchResponseModel(
    term: json["term"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "term": term,
    "count": count,
  };
}
