import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'dart:async';

import '../scoped_models/main_model.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  Widget _buildProduct(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/4.jpg'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                product.title,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 40.0,
                    fontFamily: 'SwankyMooMoo'),
              ),
              Text('\$${product.price.toString()}'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.description,
              style: TextStyle(color: Colors.grey, fontFamily: 'Oswald'),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Noida Sector-62',
                  style: TextStyle(color: Colors.grey, fontFamily: 'Oswald'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //print('Back Button Pressed');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: _buildProduct(context));
  }
}
