import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_second/data/models/product.dart';
import 'package:shop_app_second/data/models/user_product.dart';

class DatabaseProductService {
  final String? pid;
  final String? uid;

  DatabaseProductService({this.pid, this.uid});

  final CollectionReference<Map<String, dynamic>> productCollection =
      FirebaseFirestore.instance.collection("products");

  Product _productFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("product not found");
    return Product(
      // userID: data['userID'],
      productID: data['productID'],
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      price: data['price'],
    );
  }

  Stream<Product> get product {
    return productCollection.doc(pid).snapshots().map(_productFromSnapshot);
  }

//this is for fetching all the products data

  List<Product> _productListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _productFromSnapshot(doc);
    }).toList();
  }

  Stream<List<Product>> get products {
    return productCollection.snapshots().map(_productListFromSnapshot);
  }

  //*for user preffrences

  Future<void> saveUserCustomOfProducts() async {
    return await productCollection
        .doc(pid)
        .collection('user_chooses')
        .doc(uid)
        .set({
      'favorite': false,
      'color': 'default',
    });
  }

  UserProduct _userProductFromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) {
      print('no data in _userProductFromSnapshot');
      throw Exception("user in poduct prefrences not found");
    }
    return UserProduct(
      favorite: data['favorite'],
      color: data['color'],
    );
  }

  Stream<UserProduct> get inProductUserPrefrences {
    return productCollection
        .doc(pid)
        .collection('user_chooses')
        .doc(uid)
        .snapshots()
        .map(_userProductFromSnapshot);
  }

  Future<void> productFavoriteState(bool? favorite) async {
    return await productCollection
        .doc(pid)
        .collection('user_chooses')
        .doc(uid)
        .update({'favorite': favorite});
  }

  Future<void> productColorState(String? color) async {
    return await productCollection
        .doc(pid)
        .collection('user_chooses')
        .doc(uid)
        .update({'color': color});
  }
}
