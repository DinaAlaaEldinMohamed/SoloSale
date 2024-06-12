import 'package:flutter/material.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

class ProductController extends GetxController {
  List<Product>? products;
  var sqlHelper = GetIt.I.get<SqlHelper>();

  get filteredProducts => null;

  void getProducts(Function setStateCallBack) async {
    try {
      //products = [];
      var data = await sqlHelper.db!.rawQuery("""
  Select P.*,C.name as categoryName,C.description as categoryDescription from products P
  Inner JOIN categories C
  On P.categoryId = C.id
  """);

      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products?.add(Product.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
      print('Error in get Products $e');
    }
    setStateCallBack(() {});
  }

  Future<List<Product>?> getProductList(Function setStateCallBack) async {
    try {
      //products = [];
      var data = await sqlHelper.db!.rawQuery("""
  Select P.*,C.name as categoryName,C.description as categoryDescription from products P
  Inner JOIN categories C
  On P.categoryId = C.id
  """);

      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products?.add(Product.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
      print('Error in get Products $e');
    }
    setStateCallBack(() {});
    return products;
  }

  void searchProducts(String text) async {
    try {
      products = [];
      var data = await sqlHelper.db!.rawQuery("""
                Select * from products 
                where productName like '%$text%' OR productDescription like '%$text%' 
                """);
      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products?.add(Product.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
      print('Error in get Products $e');
    }
  }

  Future<List<Product>?> filterProductsList(String text) async {
    try {
      products = [];
      var data = await sqlHelper.db!.rawQuery("""
                Select * from products 
                where productName like '%$text%' OR productDescription like '%$text%' 
                """);
      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products?.add(Product.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
      print('Error in get Products $e');
    }
    return products;
  }

// add product
  Future<void> addProduct(Product product) async {
    await sqlHelper.db!.insert('products', product.toJson());
  }

  //update product
  Future<void> UpdateProduct(Product product, int? productId) async {
    await sqlHelper.db!.update('products', product.utoJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'productId =?',
        whereArgs: [productId]);
  }

  Future<Object> filterProducts(String searchText) async {
    //<Product> products;
    if (searchText.isNotEmpty) {
      var data = await sqlHelper.db!.rawQuery("""
                Select * from products 
                where productName = $searchText'
                """).toString();
      return data;
    }
    return [];
  }
}
