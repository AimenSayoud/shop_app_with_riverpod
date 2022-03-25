import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/presentation/screens/auth_screen.dart';
import 'package:shop_app_second/presentation/screens/cart_screen.dart';
import 'package:shop_app_second/presentation/screens/favorite_products_screen.dart';
import 'package:shop_app_second/presentation/screens/orders_screen.dart';
import 'package:shop_app_second/presentation/screens/product_details_screen.dart';
import 'package:shop_app_second/presentation/screens/product_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));

  // runApp(MultiProvider(providers: [
  //   ChangeNotifierProvider.value(value: CartProvider()),
  //   ChangeNotifierProvider.value(value: ProductsProvider()),
  //   ChangeNotifierProvider.value(value: OrdersProvider()),
  // ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.orange,
            primary: Colors.black,
            primaryVariant: Colors.black,
            secondaryVariant: Colors.orange),
      ),
      // theme: ThemeData(
      //   primaryColor: Colors.black,
      //   fontFamily: 'Lato',
      //   accentColor: Colors.orange,
      // ),
      routes: {
        '/': (_) => MyHomePage(),
        ProductsOverviewScreen.ROUTE_NAME: (_) => ProductsOverviewScreen(),
        ProductDetailScreen.ROUTE_NAME: (_) => ProductDetailScreen(),
        CartScreen.ROUTE_NAME: (_) => CartScreen(),
        OrdersScreen.ROUTE_NAME: (_) => OrdersScreen(),
        FavoriteProductsScreen.ROUTE_NAME: (_) => FavoriteProductsScreen(),
      },
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userStreamP = watch(userStream);

    return userStreamP.when(
      data: (userData) {
        if (userData != null) {
          return ProductsOverviewScreen();
        } else {
          return AuthScreen();
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Center(
        child: Text('something went wrong'),
      ),
    );
  }
}
