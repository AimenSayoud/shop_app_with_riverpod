import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app_second/data/databases/databse_order.dart';
import 'package:shop_app_second/data/models/cart.dart';
import 'package:shop_app_second/data/models/order.dart';
import 'package:shop_app_second/data/models/user.dart';

class OrdersProvider extends ChangeNotifier {
  Future<void> addOrder(List<CartItem> cartItems, String total, AppUser user,
      List<OrderItem> ordersList) async {
    String oid = 'Ordered-At-' + DateTime.now().toString();
    Map<String, dynamic> orderItemsMap = {};
    cartItems.forEach(
        (e) => orderItemsMap.putIfAbsent(e.pid, () => (e.quantity).toString()));

    ordersList.add(
      OrderItem(
        oid: oid,
        amount: total,
        date: Timestamp.now(),
        orderItemsMap: orderItemsMap,
      ),
    );

    final int itemIndex =
        ordersList.indexWhere((element) => element.oid == oid);

    await DatabaseOrderItemService(
            userId: user.uid, oid: ordersList[itemIndex].oid)
        .saveOrder(total, ordersList[itemIndex].date,
            ordersList[itemIndex].orderItemsMap);
    notifyListeners();
  }
}
