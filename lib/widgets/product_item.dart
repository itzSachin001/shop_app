import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_details_screen.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final authData = Provider.of<Auth>(context,listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black38,
            leading:Consumer<Product>(
              builder: (ctx, product, child) =>IconButton(icon : Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border,),
              onPressed: (){
                product.toggleFavouriteStatus(authData.token.toString(),authData.userId.toString());
              },
              color: Colors.red,
            ),
            ),

            title: Text(product.title,textAlign: TextAlign.center,),

            trailing: IconButton(
              icon:const Icon(Icons.shopping_cart),
              onPressed: (){
                cart.addItem(product.id!, product.title, product.price);

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO',onPressed: (){
                    cart.removeSingleItem(product.id!);
                  },),
                )
                );
              },),
          ),
          child: GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
              },
              child: Hero(
                tag: product.id!,
                child: FadeInImage(
                  placeholder: const AssetImage("assets/images/default_product.png"),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
          ),
        ),
    );
  }
}
