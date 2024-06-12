import 'package:flutter_pos/models/category.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class CategoryController extends GetxController {
  List<Category>? categories = [];
  var sqlHelper = GetIt.I.get<SqlHelper>();

  void getCategories(Function setStateCallBack) async {
    try {
      categories = [];
      var data = await sqlHelper.db!.query('categories');
      if (data.isNotEmpty) {
        for (var item in data) {
          categories ??= [];
          categories?.add(Category.fromJson(item));
        }
      } else {
        categories = [];
      }
      setStateCallBack(() {});
    } catch (e) {
      print('Error in get Categories $e');
    }
  }
}
