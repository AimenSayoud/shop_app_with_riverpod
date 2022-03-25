import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/data/models/cart.dart';
import 'package:shop_app_second/data/models/order.dart';
import 'package:shop_app_second/data/models/user.dart';
import 'package:shop_app_second/presentation/screens/orders_screen.dart';

class CartTotalCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<CartItem> cartsList = [];
    List<OrderItem> ordersList = [];
    final cartStreamP = watch(cartStream);
    final orderStreamP = watch(orderStream);
    final userStreamP = watch(userStream);

    if (cartStreamP.data != null) cartsList = cartStreamP.data!.value;
    if (orderStreamP.data != null) ordersList = orderStreamP.data!.value;
    AppUser? appUser = userStreamP.data!.value!;
    double totalL(List<CartItem> itemsList) {
      double total = 0;
      itemsList.forEach((cartItem) {
        var price = double.parse(cartItem.price);
        total += price * cartItem.quantity;
      });
      return total;
    }

    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '\$${totalL(cartsList).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          ButtonBar(
            children: [
              // TextButton(
              //   child: const Text('EDIT ORDER'),
              //   onPressed: () {
              //     //edit  the order in order page
              //   },
              // ),
              ElevatedButton(
                child: const Text('PLACE ORDER'),
                onPressed: () async {
                  if (totalL(cartsList) == 0.0) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('There is no items in your cart'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  await context.read(orderChangeNotifier).addOrder(
                      cartsList,
                      totalL(cartsList).toStringAsFixed(2),
                      appUser,
                      ordersList);
                  context.read(cartChangeNotifier).clear(appUser, cartsList);
                  // await cart.clear(user.data!.value!);
                  // print(appUser.uid);
                  // await context.read(cartChangeNotifier).clear(appUser);
                  await Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.ROUTE_NAME);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
