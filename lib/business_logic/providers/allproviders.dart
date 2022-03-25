import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/business_logic/providers/cart_provider.dart';
import 'package:shop_app_second/business_logic/providers/orders_provider.dart';
import 'package:shop_app_second/business_logic/providers/products_provider.dart';
import 'package:shop_app_second/data/databases/database_cart.dart';
import 'package:shop_app_second/data/databases/database_product.dart';
import 'package:shop_app_second/data/databases/databse_order.dart';
import 'package:shop_app_second/data/models/cart.dart';
import 'package:shop_app_second/data/models/order.dart';
import 'package:shop_app_second/data/models/product.dart';
import 'package:shop_app_second/data/models/user.dart';
import 'package:shop_app_second/data/models/user_product.dart';
import 'package:shop_app_second/data/services/authantication.dart';

//change notifiers

//cart class ChangeNotifier Provider
final cartChangeNotifier = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

//order class ChangeNotifier Provider
final orderChangeNotifier = ChangeNotifierProvider<OrdersProvider>((ref) {
  return OrdersProvider();
});

//product class ChangeNotifier Provider
final productsChangeNotifier = ChangeNotifierProvider<ProductsProvider>((ref) {
  String uid = ref.watch(userProvider).uid;
  return ProductsProvider(uid);
});

//streams Providers

//user Stream Provider
final userStream = StreamProvider<AppUser?>((ref) {
  return AuthenticationService().user;
});

//products Stream Provider
final productsStream = StreamProvider<List<Product>>((ref) {
  return DatabaseProductService().products;
});

//product Stream Provider
final productStream = StreamProvider.family<Product, String>((ref, pid) {
  return DatabaseProductService(pid: pid).product;
});

//product Stream Provider
final inProductUserPrefrencesStream =
    StreamProvider.family<UserProduct, String>((ref, pid) {
  String uid = ref.watch(userProvider).uid;
  return DatabaseProductService(pid: pid, uid: uid).inProductUserPrefrences;
});

//cart Stream Provider
final cartStream = StreamProvider<List<CartItem>>((ref) {
  String id = ref.watch(userProvider).uid;
  return DatabaseCartItemService(userId: id).carts;
});

//cart Stream Provider
final orderStream = StreamProvider<List<OrderItem>>((ref) {
  AsyncValue<AppUser?> userId = ref.watch(userStream);
  String id = userId.data!.value!.uid;
  return DatabaseOrderItemService(userId: id).orders;
});

//providers

//productProvider
final productProvider = Provider.family<Product, String>((ref, pid) {
  final streamProduct = ref.watch(productStream(pid));
  Product? product;
  if (streamProduct.data != null)
    product = streamProduct.data!.value;
  else
    print('no product found null product provider ');
  return product!;
});

//cart Provider
final cartProvider = Provider.family<List<CartItem>, String>((ref, pid) {
  final streamCart = ref.watch(cartStream);
  List<CartItem> cart = [];
  if (streamCart.data != null)
    cart = streamCart.data!.value;
  else
    print('no data in the cart list ');
  return cart;
});

//user Provider
final userProvider = Provider<AppUser>((ref) {
  final streamUser = ref.watch(userStream);
  AppUser user = streamUser.data!.value!;
  return user;
});
