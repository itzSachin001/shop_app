import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {

  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItems(this.id,this.productId,this.price,this.quantity,this.title);

  @override
  Widget build(BuildContext context) {
    return  Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding:const EdgeInsets.only(right: 20),
        margin:const EdgeInsets.symmetric(horizontal: 15 , vertical: 4),
        child:const Icon(Icons.delete,size: 40,color: Colors.white,),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (ctx) =>  AlertDialog(
            content:const Text('Are you sure?'),
            title:const Text('Do you want to remove item from the cart?'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'))
            ],

          ),);
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItems(productId);
      },
      child: Card(
        margin:const EdgeInsets.symmetric(horizontal: 15 , vertical: 4),
        child: Padding(
          padding:const EdgeInsets.all(8),
          child: ListTile(
            leading:  CircleAvatar(child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(child: Text('₹ $price')),
            ),),
            title: Text(title),
            subtitle: Text('Total: ₹ ${price * quantity}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
