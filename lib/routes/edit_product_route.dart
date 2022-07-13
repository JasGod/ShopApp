import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class EditProductRoute extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductRoute> createState() => _EditProductRouteState();
}

class _EditProductRouteState extends State<EditProductRoute> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  var _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct = ProductModel(
      description: '', id: null, imageUrl: '', price: 0.0, title: '');
  var _isInit = true;
  var _isLoading = true;
  var _initValue = {
    'title': '',
    'price': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageFocus);
    _isLoading = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<ProductsProviders>(context, listen: false)
            .findById(productId);
        _initValue = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
        };
        _imageController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageFocus);
    _imageController.dispose();
    _imageFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  void _updateImageFocus() {
    if ((!_imageController.text.startsWith('http') &&
            !_imageController.text.startsWith('https')) ||
        (!_imageController.text.endsWith('png') &&
            !_imageController.text.endsWith('jpg') &&
            !_imageController.text.endsWith('jpeg'))) {
      return;
    }
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<ProductsProviders>(context, listen: false)
          .updateProducts(_editProduct.id, _editProduct)
          .catchError((onError) {
        print(onError);
        throw onError;
      });
    } else {
      try {
        await Provider.of<ProductsProviders>(context, listen: false)
            .addProducts(_editProduct);
      } catch (err) {
        await showDialog(
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
        );
      } /* finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } */
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(label: Text('Title')),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = ProductModel(
                            description: _editProduct.description,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                            price: _editProduct.price,
                            title: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a title please!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(label: Text('Price')),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a number please!';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number please!';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a number upper to 0!';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = ProductModel(
                            description: _editProduct.description,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                            price: double.parse(value),
                            title: _editProduct.title);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      decoration: InputDecoration(label: Text('Description')),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editProduct = ProductModel(
                            description: value,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            imageUrl: _editProduct.imageUrl,
                            price: _editProduct.price,
                            title: _editProduct.title);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a description please!';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageController.text.isEmpty
                              ? Text(
                                  'Enter url image',
                                  textAlign: TextAlign.center,
                                )
                              : Image.network(
                                  _imageController.text,
                                  fit: BoxFit.cover,
                                  height: 100,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(label: Text('Image URL')),
                            keyboardType: TextInputType.url,
                            focusNode: _imageFocusNode,
                            controller: _imageController,
                            onEditingComplete: () {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editProduct = ProductModel(
                                  description: _editProduct.description,
                                  id: _editProduct.id,
                                  isFavorite: _editProduct.isFavorite,
                                  imageUrl: value,
                                  price: _editProduct.price,
                                  title: _editProduct.title);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter url image please!';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter  valid url please!';
                              }
                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'Enter valid url image please!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
