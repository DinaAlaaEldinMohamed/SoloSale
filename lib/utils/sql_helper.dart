import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  var path = 'pos_db6.db';
  Database? db;
  Future<void>? registerForeignKeys() async {
    await db!.execute("""PRAGMA foreign_keys = ON""");
    await db!.rawQuery(""" PRAGMA foreign_keys """);
    //
  }

  Future<bool> createTables() async {
    try {
      var batch = db!.batch();
      await registerForeignKeys();
      batch.rawQuery(""" PRAGMA foreign_keys """);

      batch.execute("""
      Create table If not exists categories(
      id integer primary key,
      name text,
      description text
      )""");
      batch.execute("""
      Create table If not exists products(
      productId integer primary key,
      productName text,
      productDescription text,
      owner text,
      price double,
      stock integer,
      isAvailable boolean,
      image blob,
      categoryId integer
      )""");
      batch.execute("""
      Create table If not exists clients(
      clientId integer primary key,
      clientName text,
      clientEmail text,
      clientPhone text,
      clientAddress text
      )""");
      batch.execute("""
      Create table If not exists orders(
      id integer primary key,
      totalPrice real,
      discount real,
      clientId integer ,
      foreign key(clientId) references clients(id)
      ON Delete restrict
      )""");
      batch.execute("""
      Create table If not exists orderProductItems(
      orderId Integer,
      productCount Integer,
      productId Integer,
      foreign key(productId) references products(id)
      ON Delete restrict
      )""");

      var result = await batch.commit();
      print('tables Created Successfully: $result');
      return true;
    } catch (e) {
      print('error in create tables $e');
      return false;
    }
  }

  Future<void> initDb() async {
    try {
      if (kIsWeb) {
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase(path);
        print(
            '=================== Database Created Successfully on web=====================');
      } else {
        db = await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) {
            print(
                '=================== Database Created Successfully=====================');
          },
        );
      }
    } catch (e) {
      print(
          '=====================Attention there is an error on creating DB ::==========>> $e');
    }
  }
}
