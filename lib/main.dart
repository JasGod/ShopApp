import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:flutter_shop_app/providers/order_provider.dart';
import 'package:flutter_shop_app/routes/auth_route.dart';
import 'package:flutter_shop_app/routes/cart_route.dart';
import 'package:flutter_shop_app/routes/edit_product_route.dart';
import 'package:flutter_shop_app/routes/order_route.dart';
import 'package:flutter_shop_app/routes/splash_route.dart';
import 'package:flutter_shop_app/routes/user_product_route.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:flutter_shop_app/routes/product_detail_route.dart';
import 'package:flutter_shop_app/routes/products_overview_route.dart';

import 'helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<AuthProvider, ProductsProviders>(
          update: (ctx, auth, previousProducts) => ProductsProviders(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (context, auth, previousOrders) => OrderProvider(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orderItems,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransistionBuilder(),
            }),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductOverviewRoute()
              : FutureBuilder(
                  future: auth.tryAutoSignin(),
                  builder: (ctx, authResultSnapshot) {
                    if (authResultSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      print("execution in future main splashroute");
                      return SplashRoute();
                    } else {
                      print("execution in future main authroute");
                      return AuthRoute();
                    }
                  }),
          routes: {
            ProductDetailRoute.routeName: (context) => ProductDetailRoute(),
            CartRoute.routeName: (context) => CartRoute(),
            OrderRoute.routeName: (context) => OrderRoute(),
            UserProductRoute.routeName: (context) => UserProductRoute(),
            EditProductRoute.routeName: (context) => EditProductRoute(),
          },
        );
      }),
    );
  }
}
