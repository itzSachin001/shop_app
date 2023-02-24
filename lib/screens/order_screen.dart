import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

import '../providers/orders.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderFuture;

  Future _obtainedOrderFuture() async{
    return await Provider.of<Order>(context ,listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainedOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // final orderData=Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }else {
            if(dataSnapshot.error != null){
              // do error handling
              return Center(child: Text('An error occurred'));
            }else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItems(orderData.orders[i]),
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
