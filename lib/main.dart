import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/app_router.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/views/home.dart';
import 'package:get_it/get_it.dart';

///
///
/// SoloSale is a flutter Point of Sale Application
///
///
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await createInstance();
  runApp(const MyApp());
}

Future<void> createInstance() async {
  var sqlHelper = SqlHelper();
  await sqlHelper.initDb();
  if (sqlHelper.db != null) {
    GetIt.I.registerSingleton<SqlHelper>(sqlHelper);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor, foregroundColor: whiteColor),
        iconTheme: const IconThemeData(color: whiteColor),
        colorScheme: ColorScheme.fromSwatch(
          errorColor: Colors.red,
          cardColor: whiteColor,
          backgroundColor: Colors.white,
          primarySwatch: getMaterialColor(primaryColor),
        ),
        dividerTheme: const DividerThemeData(
          color: veryLightGrayColor,
          thickness: 0.7,
          space: 18,
        ),
      ),
      home: const HomePage(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
