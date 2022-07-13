import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';

class ProductDetailRoute extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    var loadedProduct = ProductModel(
        description: 'description',
        id: null,
        imageUrl:
            'https://cdn.pixabay.com/photo/2014/03/25/15/19/cross-296507_960_720.png',
        price: 0,
        title: 'title');
    final productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      loadedProduct =
          Provider.of<ProductsProviders>(context).findById(productId);
    }
    return Scaffold(
      // appBar: AppBar(title: Text(loadedProduct.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.purpleAccent.withOpacity(.7),
                        Colors.amberAccent.withOpacity(.7)
                      ]).createShader(bounds);
                },
                child: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  '${loadedProduct.description}',
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 800,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
