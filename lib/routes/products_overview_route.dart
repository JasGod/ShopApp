import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/routes/cart_route.dart';
import 'package:flutter_shop_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewRoute extends StatefulWidget {
  @override
  State<ProductOverviewRoute> createState() => _ProductOverviewRouteState();
}

class _ProductOverviewRouteState extends State<ProductOverviewRoute> {
  var _showOnlyFavorites = false;
  var _isLoading = true;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProviders>(context)
          .fetchAndSetProducts()
          .then((_) {
            setState(() {
              _isLoading = false;
            });
          })
          .onError(
            (error, stackTrace) => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ),
          )
          .whenComplete(() {
            setState(() {
              _isLoading = false;
            });
          });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("product overview build");
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                badgeContent: Text(cart.cartItemCount.toString()),
              ),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartRoute.routeName),
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
