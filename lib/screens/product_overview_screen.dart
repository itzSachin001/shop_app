
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';


enum FilterOptions {
  Favourites,
  All
}

class ProductOverviewScreen extends StatefulWidget {

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {


  var _showFavouritesOnly = false;
  var _isInit = true;
  var _isLoading =false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();
    // Future.delayed(Duration.zero).then((_) =>
    //     Provider.of<Products>(context).fetchAndSetProducts()
    // );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        _isLoading = false;
      }).catchError((error){
        showDialog(context: context, builder: (ctx) => AlertDialog(
          content: Text('An error occurred!'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(ctx).pop();
            }, child: Text('Okay'))
          ],
        ),);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favourites){
                  _showFavouritesOnly = true;
                }else {
                  _showFavouritesOnly = false;
                }
              });

            },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
              const PopupMenuItem(value: FilterOptions.Favourites, child: Text('Only Favourites!')),
            const PopupMenuItem(value: FilterOptions.All, child: Text('Show All'))
            ,]),

          Consumer<Cart>(
            builder: (_,cart, ch) => Badges(
            value: cart.itemCount.toString(),
            child: ch!,
              color: Theme.of(context).accentColor,
          ),
            child: IconButton(onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);
            }, icon: const Icon(Icons.shopping_cart)),
          ),
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : ProductGrid(_showFavouritesOnly),

      drawer: AppDrawer(),

    );
  }
}
