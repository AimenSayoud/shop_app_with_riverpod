import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String oid;
  final String amount;
  final Map<String, dynamic> orderItemsMap;
  final Timestamp date;

  OrderItem({
    required this.oid,
    required this.amount,
    required this.date,
    required this.orderItemsMap,
  });
}
