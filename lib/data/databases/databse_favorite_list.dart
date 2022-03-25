import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_second/data/models/user_product.dart';

class DatabaseListOfFavProduct {
  final String? uid;

  DatabaseListOfFavProduct({ this.uid});

  final CollectionReference<Map<String, dynamic>> favoriteListCollection =
      FirebaseFirestore.instance.collection("favoriteList");

  Future<void> updateFavoriteList(List<String> favoriteList) async {
    return await favoriteListCollection.doc(uid).update({'favoriteList': favoriteList});
  }

  
  Future<void> saveFavoriteProductsList() async {
    return await favoriteListCollection
        .doc(uid)
        .set({
      'favoriteList': [],
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
      favoriteList: data['favoriteList'],
    );
  }

  Stream<UserProduct> get inProductUserPrefrences {
    return favoriteListCollection
        .doc(uid)
        .snapshots()
        .map(_userProductFromSnapshot);
  }
}
