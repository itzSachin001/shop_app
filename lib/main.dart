import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,Products>(
        update:(ctx,auth,previousProducts)=>Products(
            auth.token.toString(),
            auth.userId.toString(),
            previousProducts == null ? [] : previousProducts.items),
          create: (ctx) => Products('','',[]),
        ),
        ChangeNotifierProvider.value(
            value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx,auth,previousOrders) => Order(
                auth.token.toString(),
                auth.userId.toString(),
                previousOrders == null ? [] : previousOrders.orders),
          create: (ctx) => Order('','',[]),
        )
      ],

        child: Consumer<Auth>(
          builder:(ctx,auth ,_) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.red.shade500,
            ),
            home:auth.isAuth ? ProductOverviewScreen() : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),),
            routes: {
              ProductDetailsScreen.routeName:(ctx) => ProductDetailsScreen(),
              CartScreen.routeName:(ctx) => CartScreen(),
              OrderScreen.routeName:(ctx)=> OrderScreen(),
              UserProductScreen.routeName:(ctx)=> UserProductScreen(),
              EditProductScreen.routeName:(ctx)=> EditProductScreen(),
            },
          ),
        ),
    );
  }
}
