import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

@immutable
sealed class NetworkService {

  /// base url
  static const String _baseUrl = "dummyjson.com";

  /// api
  static const String apiGetAllProducts = "/products";
  static const String apiGetAllUsers = "/users";
  static const String apiAuthUsers = "/auth/login";
  static const String apiSearchId = "/products/";
  static const String apiSearchProduct = "/products/search";
  static const String apiSearchCategory = "/products/category";

  /// headers
  static const Map<String, String> headers = {
   "Content-Type":"application/json"
  };

  /// params
  static Map<String, Object?> paramEmpty() => const <String, Object?>{};
  static Map<String, Object?> paramSearchProducts (String productName) => <String, Object?> {
    "q":productName
  };

  /// methods

/// get Function

static Future<String?> getDate({required String api, required Map<String,Object?> param}) async {
  Uri url = Uri.https(_baseUrl, api, param);
  Response response = await get(url, headers: headers);
  if(response.statusCode <= 201) {
    return response.body;
  }else {
    return null;
  }
}

/// post Function

  static Future<String?> postDate({required String api, required Map<String,Object?> param, required Map<String, Object?> date}) async {
    Uri url = Uri.https(_baseUrl, api, param);
    Response response = await post(url,body: jsonEncode(date), headers: headers);
    if(response.statusCode <= 201) {
      return response.body;
    }else {
      return null;
    }
  }


/// update Function

  static Future<String?> updateDate({required String api, required Map<String, Object?> param, required Map<String,Object?> date}) async{
    Uri url = Uri.https(_baseUrl,api,param );
    Response response = await put(url, body: jsonEncode(date), headers:  headers);
    if(response.statusCode <= 201){
      return response.body;
    }else{
      return null;
    }
  }

/// delete Function

  static Future<String?> deleteDate({required String api, required Map<String, Object?> param, required Map<String, Object?> date}) async{
    Uri url = Uri.https(_baseUrl,api,param,);
    Response response = await delete(url, body: jsonEncode(date), headers: headers);
    if(response.statusCode <= 201){
      return response.body;
    }else{
      return null;
    }
  }

}