import 'package:flutter/foundation.dart';

class CartModel {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartModel(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title});
}

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get cartItems {
    return {..._cartItems};
  }

  int get cartItemCount {
    return _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addCartItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      // change quantity
      _cartItems.update(
          productId,
          (exitingCartItem) => CartModel(
              id: exitingCartItem.id,
              price: exitingCartItem.price,
              quantity: exitingCartItem.quantity + 1,
              title: exitingCartItem.title));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartModel(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeOneItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(
          productId,
          (existingCartItem) => CartModel(
              id: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1,
              title: existingCartItem.title));
    } else {
      _cartItems.remove(productId);
    }
  }

  void clearCartItems() {
    _cartItems = {};
    notifyListeners();
  }
}
