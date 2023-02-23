import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderItems extends StatefulWidget {
  final OrderItem order;

  OrderItems(this.order);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('₹ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 15 ,vertical: 4),
              height: min(widget.order.products.length * 25 + 10, 100),
              child: ListView(
                children: widget.order.products.map((prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(prod.title,style:const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                      textAlign: TextAlign.start,
                    ),
                    Align(child: Text('${prod.quantity}x'),alignment: Alignment.center,),
                    Text('₹ ${prod.price}')
                  ],
                )).toList()
              ),
            )
        ],
      ),
    );
  }
}
