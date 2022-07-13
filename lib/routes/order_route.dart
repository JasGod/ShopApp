import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class OrderRoute extends StatelessWidget {
  static const routeName = '/orders';
/*   Future _ordersFuture;

  Future _obtainsOrdersFuture() {
    return Provider.of<OrderProvider>(context, listen: false)
        .fetchAndSetOrders();
  } */

/*   @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainsOrdersFuture(); // used when you don't want to redo an http call each time the widget is rebuilt, whether internal or external
    Future.delayed(Duration.zero).then((value) {
      Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders();
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: //_ordersFuture,
            Provider.of<OrderProvider>(context, listen: false)
                .fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text('An error Occured!'),
            );
          } else {
            return Consumer<OrderProvider>(builder: (context, order, child) {
              return ListView.builder(
                itemBuilder: ((context, i) => OrderItem(order.orderItems[i])),
                itemCount: order.orderItems.length,
              );
            });
          }
        },
      ),
    );
  }
}
