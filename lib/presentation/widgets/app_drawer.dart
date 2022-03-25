import 'package:flutter/material.dart';
import 'package:shop_app_second/presentation/screens/favorite_products_screen.dart';
import 'package:shop_app_second/presentation/screens/orders_screen.dart';
import 'package:shop_app_second/presentation/screens/product_overview_screen.dart';
import 'package:shop_app_second/data/services/authantication.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('My Shop'),
            automaticallyImplyLeading: false,
          ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.ROUTE_NAME);
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.ROUTE_NAME);
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(FavoriteProductsScreen.ROUTE_NAME);
            },
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LogOut'),
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              await AuthenticationService().signOut();
            },
          ),
        ],
      ),
    );
  }
}
