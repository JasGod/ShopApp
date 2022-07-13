import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';

import 'package:flutter_shop_app/routes/order_route.dart';
import 'package:flutter_shop_app/routes/user_product_route.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderRoute.routeName);
/*               Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrderRoute(),
                ),
              ); */
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.post_add_rounded),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductRoute.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
