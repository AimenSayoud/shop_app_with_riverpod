import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shop_app_second/business_logic/providers/allproviders.dart';
import 'package:shop_app_second/data/models/order.dart';
import 'package:shop_app_second/data/models/product.dart';

class OrderTile extends StatefulWidget {
  final OrderItem order;

  OrderTile(this.order);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        (widget.order.date).millisecondsSinceEpoch);

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 6,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(date),
            ),
            trailing: IconButton(
              icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: _toggleExpanded,
            ),
          ),
          if (_expanded)
            Container(
                padding: EdgeInsets.all(16.0),
                child: Consumer(
                  builder: (context, watch, child) {
                    List<ListTile> listTile = [];
                    widget.order.orderItemsMap.forEach((pid, quantity) {
                      Product product = watch(productProvider(pid));
                      double total =
                          double.parse(quantity) * double.parse(product.price!);
                      listTile.add(
                        ListTile(
                          leading: Text(quantity.toString()),
                          title: Text(product.title.toString()),
                          trailing: Text('\$${total.toString()}'),
                        ),
                      );
                    });
                    return ListView(
                      children: listTile,
                    );
                  },
                ),
                height: min(
                  widget.order.orderItemsMap.length * 20.0 + 100.0,
                  180.0,
                )),
        ],
      ),
    );
  }
}
