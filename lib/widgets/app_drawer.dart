import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/sql_helper.dart';
import 'package:get_it/get_it.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var sqlIns = GetIt.I.get<SqlHelper>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('SoloSale'),
            accountEmail: Text('solo_sale@info.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/soloSale.jpg'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Sales'),
            onTap: () {
              Navigator.pushNamed(context, '/sales');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Products'),
            onTap: () {
              Navigator.pushNamed(context, '/products');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pushNamed(context, '/categories');
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Clients'),
            onTap: () {
              Navigator.pushNamed(context, '/clients');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Database'),
            onTap: () {
              sqlIns.backupDB();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Database'),
            onTap: () {
              sqlIns.deleteDB();
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Database'),
            onTap: () {
              sqlIns.restoreDB();
            },
          ),
        ],
      ),
    );
  }
}
