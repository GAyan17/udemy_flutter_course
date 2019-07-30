import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

//import './pages/product.dart';
import './price_tag.dart';
import '../../models/product.dart';
import '../../scoped_models/main_model.dart';

class Products extends StatelessWidget {
  Widget _buildProductItem(BuildContext context, Product product, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/4.jpg'),
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    product.title,
                    style:
                        TextStyle(fontSize: 40.0, fontFamily: 'SwankyMooMoo'),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  PriceTag(product.price.toString())
                ],
              )),
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0)),
              child: Text('Noida Sector-62')),
          Text(product.userEmail),
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.info),
                    color: Theme.of(context).accentColor,
                    onPressed: () => Navigator.pushNamed<bool>(
                        context, '/product/' + model.allProducts[index].id),
                  ),
                  IconButton(
                      icon: Icon(model.allProducts[index].isFavourite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      color: Colors.red,
                      onPressed: () {
                        model.selectProduct(model.allProducts[index].id);
                        model.toggleProductFavouriteStatus();
                      })
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    Widget productCard =
        Center(child: Text('No Products Found, please add some'));
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _buildProductItem(context, products[index], index);
        },
        itemCount: products.length,
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    });
  }
}
