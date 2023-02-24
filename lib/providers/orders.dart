import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Order(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async{
    final url = Uri.parse('https://shop-app-a2946-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> _loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String , dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      _loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']), 
        products: (orderData['products'] as List<dynamic>).map((item) =>
            CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']
            )).toList(),
      ));
    });
    _orders = _loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItem, double total) async{
    final url = Uri.parse('https://shop-app-a2946-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(url,body: json.encode({
      'amount': total,
      'dateTime': timeStamp.toIso8601String(),
      'products': cartItem.map((cp) => {
        'id': cp.id,
        'price': cp.price,
        'quantity': cp.quantity,
        'title': cp.title
      }).toList()
    }));
    _orders.insert(0, OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartItem,
            dateTime: timeStamp
    ));
    notifyListeners();
  }
}
