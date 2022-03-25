import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/data/models/cart.dart';
import 'package:shop_app_second/data/models/user.dart';

class CartListTile extends ConsumerWidget {
  final CartItem cartItem;
  final String productId;

  CartListTile(this.cartItem, this.productId);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var totalPrice = double.parse(cartItem.price) * cartItem.quantity;
    final user = watch(userStream);
    final cartStreamP = watch(cartStream);
    AppUser? appUser = user.data!.value!;
    List<CartItem> cartsList = [];
    return Dismissible(
      key: ValueKey(cartItem.cid),
      onDismissed: (direction) async {
        if (cartStreamP.data != null) {
          cartsList = cartStreamP.data!.value;
        }
        await context
            .read(cartChangeNotifier)
            .removeItem(productId, appUser, cartsList);
      },
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This operation cannot be undone.'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      ),
      background: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.delete, color: Colors.white),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 8.0,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Card(
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 8.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                child: Text(
                  cartItem.quantity.toString(),
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.black12,
              ),
              SizedBox(width: 16.0),
              Text(
                cartItem.title,
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
