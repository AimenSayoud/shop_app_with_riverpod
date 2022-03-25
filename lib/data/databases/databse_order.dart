import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_second/data/models/order.dart';

class DatabaseOrderItemService {
  final String? oid;
  final String userId;

  DatabaseOrderItemService({this.oid, required this.userId});

  final CollectionReference<Map<String, dynamic>> orderCollection =
      FirebaseFirestore.instance.collection("orders");

  Future<void> saveOrder(
      String amount, Timestamp date, Map<String, dynamic> orderItemsMap) async {
    await orderCollection.doc(userId).collection('order_items').doc(oid).set({
      'oid': oid,
      'amount': amount,
      'date': date,
      'orderItemsMap': orderItemsMap,
    });
  }

  Future<void> removeItem() async {
    await orderCollection
        .doc(userId)
        .collection('order_items')
        .doc(oid)
        .delete();
  }

  Future<void> clearItems() async {
    await orderCollection.doc(userId).delete();
  }

  OrderItem _orderFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("order not found");

    return OrderItem(
      oid: data['oid'],
      amount: data['amount'],
      date: data['date'],
      orderItemsMap: data['orderItemsMap'],
    );
  }

  //this is for fetching all the orders data
  List<OrderItem> _orderListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _orderFromSnapshot(doc);
    }).toList();
  }

  Stream<List<OrderItem>> get orders {
    return orderCollection
        .doc(userId)
        .collection('order_items')
        .snapshots()
        .map(_orderListFromSnapshot);
  }
}
