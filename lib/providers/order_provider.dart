import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shop_app/models/order_model.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orderItems = [];

  List<OrderModel> get orderItems {
    return [..._orderItems];
  }

  final String authToken;
  final String authUserId;

  OrderProvider(this.authToken, this.authUserId, this._orderItems);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-update-27c3d-default-rtdb.europe-west1.firebasedatabase.app/orders/$authUserId.json?auth=$authToken');
    final response = await http.get(url);
    final extractData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return;
    }
    final List<OrderModel> loadedOrders = [];
    extractData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderModel(
          amount: orderData['total'],
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderData['id'],
          products: (orderData['cartProducts'] as List<dynamic>)
              .map(
                (item) => CartModel(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']),
              )
              .toList(),
        ),
      );
    });
    _orderItems = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrderItem(double total, List<CartModel> cartProducts) async {
    final url = Uri.parse(
        'https://flutter-update-27c3d-default-rtdb.europe-west1.firebasedatabase.app/orders/$authUserId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'total': total,
        'dateTime': timeStamp.toIso8601String(),
        'cartProducts': cartProducts
            .map((cp) => {
                  'title': cp.title,
                  'id': cp.id,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orderItems.insert(
        0,
        OrderModel(
            amount: total,
            dateTime: timeStamp,
            id: jsonDecode(response.body)['name'],
            products: cartProducts));
    notifyListeners();
  }
}
