import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/presentation/widgets/cart/cart_tile.dart';

class CartItemsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final cartStreamP = watch(cartStream);
    final List<String> productIds = [];

    return cartStreamP.when(
      data: (cartList) {
        cartList.forEach((element) {
          productIds.add(element.pid);
        });
        return Expanded(
          child: ListView.builder(
            itemCount: cartList.length,
            itemBuilder: (_, i) => CartListTile(cartList[i], productIds[i]),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('oops'),
    );
  }
}
