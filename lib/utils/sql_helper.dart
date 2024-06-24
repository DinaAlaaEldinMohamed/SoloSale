import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_pos/models/currency.dart';
import 'package:flutter_pos/models/exchange_rate.dart';
import 'package:flutter_pos/utils/app_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  var dbFile = 'pos_db6.db';
  List<Currency>? currencies;
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
      paidCurrency text,
      label text,
      discount real,
      orderComment text,
      orderDate text,
      clientId integer ,
      foreign key(clientId) references clients(clientId)
      ON Delete restrict
      )""");
      batch.execute("""
      Create table If not exists orderProductItems(
      orderId Integer,
      productCount Integer,
      productId Integer,
      foreign key(productId) references products(productId)
      ON Delete restrict
      )""");
      batch.execute("""
      Create table If not exists currencies(
        code TEXT PRIMARY KEY,
        name TEXT,
        symbol TEXT
      )""");
      batch.execute("""
      Create table If not exists exchangeRates(
      baseCurrency TEXT,
      targetCurrency TEXT,
      rate REAL
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
        db = await factory.openDatabase(dbFile);
        print(
            '=================== Database Created Successfully on web=====================');
      } else {
        db = await openDatabase(
          dbFile,
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

//==========================Database Backup=========================
  Future<void> backupDB() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    String dbPath = await getDatabasesPath();
    try {
      Directory? backupDir = await getExternalStorageDirectory();
      if (backupDir != null) {
        Directory backupPath =
            Directory('${backupDir.path}/SoloSaleDataBaseBackup');
        await backupPath.create(recursive: true);

        File ourDBFile = File('$dbPath/$dbFile');
        await ourDBFile.copy('${backupPath.path}/$dbFile');
        print('Database backup successful.');
      } else {
        print('Error: External storage directory is null.');
      }
    } catch (e) {
      print('Error during database backup: $e');
    }
  }

//=======================================Database Restore=================
  Future<void> restoreDB() async {
    String dbPath = await getDatabasesPath();

    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    var status1 = await Permission.storage.status;
    if (!status1.isGranted) {
      await Permission.storage.request();
    }

    try {
      Directory? backupDir = await getExternalStorageDirectory();
      if (backupDir != null) {
        Directory backupPath =
            Directory('${backupDir.path}/SoloSaleDataBaseBackup');
        if (await backupPath.exists()) {
          File savedDBFile = File('${backupPath.path}/$dbFile');
          if (await savedDBFile.exists()) {
            await savedDBFile.copy('$dbPath/$dbFile');
            print('Database restore successful.');
          } else {
            print('Error: Backup file does not exist.');
          }
        } else {
          print('Error: Backup folder does not exist.');
        }
      } else {
        print('Error: External storage directory is null.');
      }
    } catch (e) {
      print('Error during database restore: $e');
    }
  }

  deleteDB() async {
    try {
      String dbPath = await getDatabasesPath();

      db = null;
      deleteDatabase('$dbPath/$dbFile');
    } catch (e) {
      print("======================there is error on database delete :$e");
    }
  }

  getDbPath() async {
    String dbPath = await getDatabasesPath();
    print('====================database path:$dbPath');
    Directory? externalStoragePath = await getExternalStorageDirectory();
    print('====================externalStoragePath:$externalStoragePath');
  }

//=================DataBase Seed====================================
  Future<void> seedDatabase() async {
    try {
      // Check if data already exists
      final currenciesExist =
          await db!.rawQuery("SELECT COUNT(*) FROM currencies");
      final exchangeRatesExist =
          await db!.rawQuery("SELECT COUNT(*) FROM exchangeRates");

      if (currenciesExist.isNotEmpty && exchangeRatesExist.isNotEmpty) {
        print('Data already exists. Skipping seed.');
        return; // Data already inserted, no need to proceed further
      }

      // Insert currencies
      final usd = Currency.fromJson(
          {'code': "USD", 'name': "US Dollar", 'symbol': "\$"});
      final egp = Currency.fromJson(
          {'code': 'EGP', 'name': 'Egyptian Pound', 'symbol': '£'});
      final eur =
          Currency.fromJson({'code': 'EUR', 'name': 'Euro', 'symbol': '€'});

      await db!.insert('currencies', usd.toJson());
      await db!.insert('currencies', egp.toJson());
      await db!.insert('currencies', eur.toJson());

      // Insert exchange rates
      final usdToEgp =
          ExchangeRate(baseCurrency: 'EGP', targetCurrency: 'USD', rate: 47.65);
      final eurToEgp =
          ExchangeRate(baseCurrency: 'EGP', targetCurrency: 'EUR', rate: 51.42);
      await db!.insert('exchangeRates', usdToEgp.toJson());
      await db!.insert('exchangeRates', eurToEgp.toJson());

      print('Seed inserted successfully!');
    } catch (e) {
      print('Error on seed currency and exchange rate: $e');
    }
  }

//========================get currencies==========================
  void getCurrencies(Function setStateCallBack) async {
    try {
      //clients = [];
      var data = await db!.query('currencies');

      if (data.isNotEmpty) {
        currencies = [];
        for (var item in data) {
          currencies?.add(Currency.fromJson(item));
          print(item);
        }
      } else {
        currencies = [];
      }
    } catch (e) {
      currencies = [];
      print('Error in get  $e');
    }
    setStateCallBack(() {});
  }

  Future<double> exchangeRate(
      {String targetCurrency = 'USD', String baseCurrency = 'EGP'}) async {
    try {
      var rate = await db?.rawQuery(
          """SELECT rate FROM exchangeRates WHERE targetCurrency='$targetCurrency' AND baseCurrency='$baseCurrency'""");
      if (rate != null && rate.isNotEmpty) {
        return rate.first['rate'] as double;
      }
      if (baseCurrency == targetCurrency) {
        return 1;
      }
    } catch (e) {
      print(
          "Attention !!! an error happened when tring to got exchange rate =>error :$e");
    }
    return 0.0;
  }

  Future<String> getOrderPaidCurrency() async {
    try {
      await db?.delete('orders', where: 'paidCurrency IS NULL');
      var paidCurrency = await db?.rawQuery("""SELECT paidCurrency
      FROM orders
      GROUP BY paidCurrency
      ORDER BY COUNT(*) DESC
      LIMIT 1""");
      print(
          'paidCurrency===========================================================================$paidCurrency');
      if (paidCurrency != null && paidCurrency.isNotEmpty) {
        return paidCurrency.first['paidCurrency'] as String;
      }
    } catch (e) {
      print(
          "Attention !!! an error happened when tring to got Order paidCurrency =>error :$e");
    }
    return '';
  }

  Future<double> getTodayTotalSales({String paidCurrency = 'EGP'}) async {
    try {
      final formattedDate = formatDate(currentDateTime);
      // Query to calculate total sales for today
      final result = await db?.rawQuery('''
      SELECT SUM(totalPrice) AS todayTotalSales
      FROM orders
      WHERE orderDate LIKE '$formattedDate%'
      and paidCurrency ='$paidCurrency'
    ''');

      if (result != null && result.isNotEmpty) {
        final totalSales = result.first['todayTotalSales'] as double;
        return totalSales;
      } else {
        return 0.0;
      }
    } catch (e) {
      print("Error occurred while fetching today's total sales: $e");
      return 0.0;
    }
  }

  Future<Map<String, double>> getTodayTotalSalesWithCurrency() async {
    try {
      // Get the current date in 'YYYY-MM-DD' format
      final currentDateTime = DateTime.now();
      final formattedDate =
          '${currentDateTime.year}-${currentDateTime.month.toString().padLeft(2, '0')}-${currentDateTime.day.toString().padLeft(2, '0')}';

      // Query to calculate total sales for the current date
      final result = await db?.rawQuery('''
      SELECT paidCurrency,SUM(totalPrice) AS todayTotalSales
      FROM orders
      WHERE orderDate LIKE '$formattedDate%'
    ''');
      final todaySalesMap = <String, double>{};
      if (result != null) {
        for (final row in result) {
          final currency = row['paidCurrency'] as String;
          final totalSales = row['total_sales'] as double;
          todaySalesMap[currency] = totalSales;
        }
      }

      return todaySalesMap;
    } catch (e) {
      print(
          "Attention !!! an error happened when tring to got Order  Today Total Sales with its currency =>error :$e");
      return {};
    }
  }
}
