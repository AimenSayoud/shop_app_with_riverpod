import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/presentation/widgets/app_drawer.dart';
import 'package:shop_app_second/presentation/widgets/order_tile.dart';

class OrdersScreen extends ConsumerWidget {
  static const ROUTE_NAME = '/orders';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final orderStreamP = watch(orderStream);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: orderStreamP.when(
        data: (orderData) {
          return ListView.builder(
            itemCount: orderData.length,
            itemBuilder: (ctx, i) => OrderTile(orderData[i]),
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (e, _) {
          print(e.toString());
          return Text(e.toString());
        },
      ),
    );
  }
}
