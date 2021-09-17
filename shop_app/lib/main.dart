import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './screens/products_overview_screen.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../providers/orders.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';
import '../helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        //<o tipo de dados que dependemos, o tipo de dado que iremos fornecer>
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (BuildContext ctx, auth, previousProductsState) => Products(
            auth.token,
            previousProductsState != null ? previousProductsState.items : [],
            auth.userId,
          ),
          create: (BuildContext ctx2) => Products(
            Provider.of<Auth>(ctx2, listen: false).token,
            [],
            Provider.of<Auth>(ctx2, listen: false).userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders != null ? previousOrders.orders : [],
          ),
          create: (BuildContext ctx3) => Orders(
            Provider.of<Auth>(ctx3, listen: false).token,
            Provider.of<Auth>(ctx3, listen: false).userId,
            [],
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (BuildContext ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          /*checamos se o usuário está autenticado
          caso não esteja, tentamos o autoLogin()
          durante o processo mostramos uma loadingScreen
          caso o token tenha expirado ou é a primeira vez
          mostramos a AuthScreen() */
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
