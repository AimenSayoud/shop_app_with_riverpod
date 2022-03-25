import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/data/models/user.dart';
import 'package:shop_app_second/presentation/screens/cart_screen.dart';
import 'package:shop_app_second/presentation/widgets/app_drawer.dart';
import 'package:shop_app_second/presentation/widgets/product/products_grid.dart';

import '../widgets/badge.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const ROUTE_NAME = '/product-overview-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Consumer(builder: (ctx, watch, child) {
            final cartProvStream = watch(cartStream);
            return cartProvStream.when(
              data: (cartsList) {
                int itemCountVar =
                    context.read(cartChangeNotifier).itemLCount(cartsList);
                return Badge(
                  color: Colors.orange,
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.ROUTE_NAME);
                    },
                  ),
                  value: itemCountVar.toString(),
                );
              },
              loading: () => IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.ROUTE_NAME);
                },
              ),
              error: (e, _) => Text(e.toString()),
            );
          }),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(),
    );
  }
}
