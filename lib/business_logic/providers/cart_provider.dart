import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app_second/data/models/cart.dart';
import 'package:shop_app_second/data/models/product.dart';
import 'package:shop_app_second/data/models/user.dart';
import 'package:shop_app_second/data/databases/database_cart.dart';

class CartProvider extends ChangeNotifier {
  // Map<String, CartItem> _items = {};

  int itemLCount(List<CartItem> itemsList) {
    int count = 0;
    itemsList.forEach((item) {
      count += item.quantity;
    });
    return count;
  }

  Future<void> addItem(
      Product product, AppUser user, List<CartItem> cartsList) async {
    final int itemIndex =
        cartsList.indexWhere((element) => element.pid == product.productID);
    if (itemIndex >= 0) {
      cartsList[itemIndex].quantity += 1;
      await DatabaseCartItemService(
              userId: user.uid, cid: cartsList[itemIndex].cid)
          .cartQuantityUpdate(cartsList[itemIndex].quantity);
    } else {
      cartsList.add(
        CartItem(
          pid: product.productID!,
          cid: DateTime.now().toString(),
          title: product.title!,
          quantity: 1,
          price: product.price!,
        ),
      );
      int newIndex =
          cartsList.indexWhere((element) => element.pid == product.productID!);
      if (newIndex >= 0) {
        await DatabaseCartItemService(
                userId: user.uid, cid: cartsList[newIndex].cid)
            .saveCart(
          cartsList[newIndex].pid,
          cartsList[newIndex].title,
          cartsList[newIndex].quantity,
          cartsList[newIndex].price,
        );
      }
    }

    notifyListeners();
  }

  Future<void> removeItem(
      String productId, AppUser user, List<CartItem> cartsL) async {
    final itemIndex = cartsL.indexWhere((element) => element.pid == productId);
    if (itemIndex >= 0) {
      await DatabaseCartItemService(
              userId: user.uid, cid: cartsL[itemIndex].cid)
          .removeItem();
    } else {
      print('we couldn\'t remove the product ');
    }
    notifyListeners();
  }

  Future<void> clear(AppUser user, List<CartItem> cartsL) async {
    cartsL.forEach((element) async {
      await DatabaseCartItemService(userId: user.uid, cid: element.cid)
          .removeItem();
    });
    // await DatabaseCartItemService(userId: user.uid).clearItems();
    notifyListeners();
  }

  Future<void> removeProduct(
      String productId, AppUser user, List<CartItem> cartsL) async {
    final itemIndex = cartsL.indexWhere((element) => element.pid == productId);
    if (itemIndex < 0) {
      return;
    }
    if (cartsL[itemIndex].quantity > 1) {
      cartsL[itemIndex].quantity -= 1;
      await DatabaseCartItemService(
              userId: user.uid, cid: cartsL[itemIndex].cid)
          .cartQuantityUpdate(cartsL[itemIndex].quantity);
    } else {
      await DatabaseCartItemService(
              userId: user.uid, cid: cartsL[itemIndex].cid)
          .removeItem();
    }
    notifyListeners();
  }
}
