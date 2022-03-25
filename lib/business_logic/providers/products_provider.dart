import 'package:flutter/material.dart';
import 'package:shop_app_second/data/databases/database_product.dart';
import 'package:shop_app_second/data/databases/databse_favorite_list.dart';
import 'package:shop_app_second/data/models/user_product.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider(this.uid);

  final String uid;

  Future<void> favoriteProducts(String uid) async {
    List<String> favoritePid = [];
    //0: we should now how many products we have
    //*check if the list of fav exist
    UserProduct? userProduct =
        await DatabaseListOfFavProduct(uid: uid).inProductUserPrefrences.first;
    if (userProduct.favoriteList == null) {
      await DatabaseListOfFavProduct(uid: uid).saveFavoriteProductsList();
    }

    //1: bring all the products favorite case from the firebase
    for (int i = 1; i < 3; i++) {
      UserProduct userProduct =
          await DatabaseProductService(pid: "p$i", uid: uid)
              .inProductUserPrefrences
              .first;
      if (userProduct.favorite!) {
        //2: if the product favorite is true add it to the list
        favoritePid.add("p$i");
      } else {
        //3: if it became false delete it from the list
        favoritePid.remove('p$i');
      }
    }
    //4: add to firebase
    DatabaseListOfFavProduct(uid: uid).updateFavoriteList(favoritePid);
  }

  Future<void> ifItIsNotFirstTime(
      UserProduct? productCostum, String uid) async {
    //user product Provider
    //start the condition;
    if (productCostum == null) {
      print('no user product costum ');
      print('trying to create user product pref ');
      for (int i = 1; i < 3; i++) {
        await DatabaseProductService(pid: "p$i", uid: uid)
            .saveUserCustomOfProducts();
      }
      print('end creating user product preef ');
    } else {
      print(' user product costum exist');
    }
    ChangeNotifier();
  }

  Future<void> updateFavoriteFromDataBase(bool? favorite, String pid) async {
    await DatabaseProductService(uid: uid, pid: pid)
        .productFavoriteState(!favorite!);
    ChangeNotifier();
  }

  Future<void> updateColorFromDataBase(String? color, String pid) async {
    await DatabaseProductService(uid: uid, pid: pid).productColorState(color);
    ChangeNotifier();
  }

// Product findById(String id) {
//   return _itemsFromFireBase.firstWhere(
//     (product) => product.productID == id,
//     orElse: () {
//       return Product(
//           productID: 'no id',
//           title: 'null',
//           description: 'null',
//           imageUrl: 'null',
//           price: 00);
//     },
//   );
// }
}
