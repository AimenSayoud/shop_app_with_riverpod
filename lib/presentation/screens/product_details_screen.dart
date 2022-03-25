import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';

class ProductDetailScreen extends ConsumerWidget {
  static const ROUTE_NAME = '/product-detail';

  @override
  Widget build(BuildContext context, Reader watch) {
    bool isFavorite = false;
    final pid = ModalRoute.of(context)!.settings.arguments as String;
    final productProviderV = watch(productProvider(pid));
    final userCostumPS = watch(inProductUserPrefrencesStream(pid));

    return Scaffold(
      appBar: AppBar(
        title: Text(productProviderV.title!),
      ),
      body: productProviderV.title == null
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Hero(
                      tag: pid,
                      child: Image.network(
                        productProviderV.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${(productProviderV.price!)}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      productProviderV.description!,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //add prefrences
          await context
              .read(productsChangeNotifier)
              .updateFavoriteFromDataBase(isFavorite, pid);
        },
        child: userCostumPS.when(data: (data) {
          String uid = watch(userProvider).uid;
          context.read(productsChangeNotifier).ifItIsNotFirstTime(data, uid);
          print(isFavorite);
          isFavorite = data.favorite!;
          return Icon(data.favorite! ? Icons.star_border : Icons.star);
        }, loading: () {
          return Icon(Icons.star_border);
        }, error: (e, _) {
          print("there is an error");
          return Icon(Icons.error);
        }),
      ),
    );
  }
}
