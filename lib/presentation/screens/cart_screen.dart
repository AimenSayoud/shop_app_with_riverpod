import 'package:flutter/material.dart';
import 'package:shop_app_second/presentation/widgets/cart/cart_item.dart';
import 'package:shop_app_second/presentation/widgets/cart/cart_total_cats.dart';

class CartScreen extends StatelessWidget {
  static const ROUTE_NAME = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        child: Column(
          children: [
            CartTotalCard(),
            CartItemsList(),
            Positioned(
                bottom: 10,
                child: Text(
                  'swipe left to delete The Items from the Cart',
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                )),
          ],
        ),
      ),
    );
  }
}
