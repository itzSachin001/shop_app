import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_product_screen.dart';

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
              builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting
                  ? SplashScreen()
                  : AuthScreen(),),
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
