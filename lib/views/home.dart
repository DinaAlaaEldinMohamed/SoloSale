import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/const.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:flutter_pos/widgets/grid_view.dart';
import 'package:flutter_pos/widgets/info_header.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  bool tablesCreated = false;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    tablesCreated = await GetIt.I.get<SqlHelper>().createTables();

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: const Drawer(),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'SoloSale',
                        style: TextStyle(
                          fontSize: 24,
                          color: whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: isLoading
                              ? Transform.scale(
                                  scale: .5,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      tablesCreated ? Colors.green : Colors.red,
                                )),
                    ],
                  ),
                  const SizedBox(height: 25),
                  InfoHeader(
                    title: 'Exchange Rate',
                    trailing: '1 USD = 47.45 EGP',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  InfoHeader(
                    title: 'Today\'s Sales',
                    trailing: '233 USD = 10996.40 EGP',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              color: const Color(0xfffbfafb),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: [
                    const GridViewItem(
                      color: Color(0xFFFDF0D6),
                      route: '/sales',
                      label: 'All Sales',
                      child: Icon(
                        Icons.receipt,
                        color: Color(0xFFE49639),
                      ),
                    ),
                    GridViewItem(
                      color: const Color(0xFFFCE2E6),
                      route: '/products',
                      label: 'Products',
                      child: Image.asset(
                        'assets/images/products.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const GridViewItem(
                      color: Color(0xFFDFF7FF),
                      route: '/clients',
                      label: 'Clients',
                      child: Icon(
                        Icons.people,
                        color: Color(0xFF00C2FF),
                      ),
                    ),
                    const GridViewItem(
                      color: Color(0xFFDAF9DA),
                      route: '/sales/add',
                      label: 'New Sale',
                      child: Icon(
                        Icons.shopping_basket,
                        color: Color(0xFF64BE62),
                      ),
                    ),
                    const GridViewItem(
                      color: Color.fromARGB(255, 228, 168, 243),
                      route: '/categories',
                      label: 'Categories',
                      child: Icon(
                        Icons.category,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
