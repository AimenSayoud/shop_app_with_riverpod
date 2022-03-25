import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app_second/presentation/widgets/app_drawer.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({Key? key}) : super(key: key);
  static const ROUTE_NAME = '/favorite-page';

  @override
  _FavoriteProductsScreenState createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  List<String> favoriteProducts = [];
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("favorite products"),
      ),
      body: Consumer(builder: (context, watch, child) {
        return Container();
      }),
    );
  }
}
