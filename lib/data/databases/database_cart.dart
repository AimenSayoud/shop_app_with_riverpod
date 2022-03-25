import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_second/data/models/cart.dart';

class DatabaseCartItemService {
  final String? cid;
  final String userId;

  DatabaseCartItemService({this.cid, required this.userId});

  final CollectionReference<Map<String, dynamic>> cartCollection =
      FirebaseFirestore.instance.collection("carts");

  Future<void> saveCart(
      String pid, String title, int quantity, String price) async {
    return await cartCollection
        .doc(userId)
        .collection('cart_items')
        .doc(cid)
        .set({
      'pid': pid,
      'cid': cid,
      'title': title,
      'quantity': quantity,
      'price': price,
    });
  }

  Future<void> cartQuantityUpdate(int? quantity) async {
    return await cartCollection
        .doc(userId)
        .collection('cart_items')
        .doc(cid)
        .update({'quantity': quantity});
  }

  Future<void> removeItem() async {
    await cartCollection.doc(userId).collection('cart_items').doc(cid).delete();
  }

  Future<void> clearItems() async {
    await cartCollection.doc(userId).delete();
  }

  CartItem _cartFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("cart not found");
    return CartItem(
      // userID: data['userID'],
      pid: data['pid'],
      cid: data['cid'],
      title: data['title'],
      price: data['price'],
      quantity: data['quantity'],
    );
  }

  Stream<CartItem> get item {
    return cartCollection
        .doc(userId)
        .collection('cart_items')
        .doc(cid)
        .snapshots()
        .map(_cartFromSnapshot);
  }

  //this is for fetching all the carts data
  List<CartItem> _cartListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    // Map<String, CartItem> _items = {};
    return snapshot.docs.map((doc) {
      return _cartFromSnapshot(doc);
    }).toList();
    // listOfCartItems.forEach((element) {
    //   _items.putIfAbsent(element.pid, () => element);
    // });
    // return _items;
  }

  Stream<List<CartItem>> get carts {
    return cartCollection
        .doc(userId)
        .collection('cart_items')
        .snapshots()
        .map(_cartListFromSnapshot);
  }
}
