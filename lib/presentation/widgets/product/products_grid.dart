import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';

import 'product_item.dart';

class ProductGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final products = watch(productsChangeNotifier);
    final productsStreamP = watch(productsStream);
    return productsStreamP.when(
      //TODO: find way to call saveUserIdInProduct from change notifier to create user custom  products to be user in favorite and color
      data: (productsData) {
        return GridView.builder(
          itemCount: productsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (ctx, i) {
            return ProductItem(productsData[i].productID!);
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text(e.toString()),
    );
  }
}
