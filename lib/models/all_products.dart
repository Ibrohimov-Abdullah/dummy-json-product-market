import 'dart:convert';

import 'package:network_learning/models/products_model.dart';
AllProductModel allProductModelFromJson(String str) => AllProductModel.fromJson(json.decode(str));
String allProductModelToJson(AllProductModel data) => json.encode(data.toJson());

class AllProductModel {
  AllProductModel({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  AllProductModel.fromJson(dynamic json) {
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['skip'] = skip;
    map['limit'] = limit;
    return map;
  }

}