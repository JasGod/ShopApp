import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartModel> products;
  final DateTime dateTime;

  OrderModel(
      {@required this.amount,
      @required this.dateTime,
      @required this.id,
      @required this.products});
}
