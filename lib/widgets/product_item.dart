import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/models/product_model.dart';
import 'package:flutter_shop_app/providers/cart_provider.dart';
import 'package:flutter_shop_app/routes/product_detail_route.dart';

class ProductItem extends StatelessWidget {
/*   final String id;
  final String title;
  final String imageUrl;

  ProductItem({this.id, this.imageUrl, this.title}); */

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context);
    final theme = Theme.of(context);
    final cart = Provider.of<CartProvider>(context);
    final scaffold = ScaffoldMessenger.of(context);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailRoute.routeName, arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () async {
              product
                  .toggleFavoris(authData.token, authData.userId)
                  .onError((error, stackTrace) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      'favoriting failed',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                print('error favorite');
              });
            },
            color: theme.colorScheme.secondary,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addCartItem(product.id, product.title, product.price);
              scaffold.hideCurrentSnackBar();
              scaffold.showSnackBar(SnackBar(
                content: Text('Product add to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeOneItem(product.id);
                  },
                ),
              ));
            },
            color: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
