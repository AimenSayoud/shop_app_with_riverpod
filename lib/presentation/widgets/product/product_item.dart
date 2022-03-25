import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/data/models/cart.dart';
import 'package:shop_app_second/data/models/user.dart';
import 'package:shop_app_second/presentation/screens/product_details_screen.dart';

class ProductItem extends ConsumerWidget {
  ProductItem(this.pid);

  final String pid;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    List<CartItem> cartList = [];
    AppUser appUser = watch(userProvider);
    cartList = watch(cartProvider(pid));
    final productStreamP = watch(productStream(pid));
    //*user product start
    /*
    final userCostumP = watch(userCostumProductStreamProvider(pid));
    if (userCostumP.data != null) {
      UserProduct userProduct = userCostumP.data!.value;
      if (userProduct.favorite == null) {
        isFavorite = false;
      } else {
        isFavorite = userProduct.favorite!;
      }
    } else {
      print('no user product costum ');
    }*/
    //*user product end

    return productStreamP.when(
      data: (product) {
        return Container(
          margin: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: GridTile(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailScreen.ROUTE_NAME,
                  arguments: pid,
                ),
                child: Hero(
                  tag: product.productID!,
                  child: FadeInImage(
                    placeholder:
                        AssetImage('assets/images/default_product_image.png'),
                    image: NetworkImage(
                      product.imageUrl!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  product.title!,
                  textAlign: TextAlign.center,
                ),
/*                 leading: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () async {
                    await context
                        .read(productsChangeNotifier)
                        .updateFavoriteFromDataBase(
                            !product.favorite!, pid, appUser.uid);
                    // await DatabaseProductService(pid: pid)
                    //     .productFavoriteState(!product.favorite!);
                    print('favorite updated');
                  },
                ), */
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () async {
                    await context
                        .read(cartChangeNotifier)
                        .addItem(product, appUser, cartList);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added item to cart'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () async {
                            await context
                                .read(cartChangeNotifier)
                                .removeProduct(
                                    product.productID!, appUser, cartList);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('oops'),
    );
  }
}
/*

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),
),
*/
