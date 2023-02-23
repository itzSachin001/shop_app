import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({required this.id,
    required this.title,
    required this.quantity,
    required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String prodId, String title, double price) {
    if (_items.containsKey(prodId)) {
      //.... change quantity
      _items.update(prodId, (existingCartItem) =>
          CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1
          ));
    } else {
      _items.putIfAbsent(
          prodId,
              () =>
              CartItem(
                  id: DateTime.now().toString(),
                  title: title,
                  price: price,
                  quantity: 1
              ));
    }
    notifyListeners();
  }

  void removeItems(String prodId){
    _items.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(String prodId){
    if(!_items.containsKey(prodId)){
      return;
    }
    if(_items[prodId]!.quantity > 1){
      _items.update(prodId, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
      ));
    }else {
      _items.remove(prodId);
    }
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }
}
