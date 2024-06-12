import 'package:flutter/material.dart';
import 'package:flutter_pos/views/categories/category_ops.dart';
import 'package:flutter_pos/views/categories/categories.dart';
import 'package:flutter_pos/views/clients/client_crud_screen.dart';
import 'package:flutter_pos/views/clients/clients_list_screen.dart';
import 'package:flutter_pos/views/home.dart';
import 'package:flutter_pos/views/loading.dart';
import 'package:flutter_pos/views/products/products_crud_screen.dart';
import 'package:flutter_pos/views/products/products_list_screen.dart';
import 'package:flutter_pos/views/sales/sales_crud_screen.dart';
import 'package:flutter_pos/views/sales/sales_list_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/products':
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case '/products/add':
        return MaterialPageRoute(builder: (_) => const ProductCrudScreen());
      case '/sales':
        return MaterialPageRoute(builder: (_) => const SalesListScreen());
      case '/sales/add':
        return MaterialPageRoute(builder: (_) => const SalesCrudScreen());
      case '/clients':
        return MaterialPageRoute(builder: (_) => const ClientListScreen());
      case '/clients/add':
        return MaterialPageRoute(builder: (_) => const ClientCrudScreen());

      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesPage());
      case '/categories/add':
        return MaterialPageRoute(builder: (_) => const AddCategory());
      default:
        return MaterialPageRoute(builder: (_) => const Loading());
    }
  }
}
