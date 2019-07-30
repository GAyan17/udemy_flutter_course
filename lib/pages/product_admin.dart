import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../scoped_models/main_model.dart';
import '../widgets/ui_elements/log_out_tile.dart';

class ProductAdminPage extends StatelessWidget {
  final MainModel model;

  ProductAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Products'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/productspage'),
          ),
          Divider(),
          LogOutListTile()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Manage Text'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              icon: Icon(Icons.create),
              text: 'Create Product',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'My Products',
            )
          ]),
        ),
        body: TabBarView(
            children: <Widget>[ProductEditPage(), ProductListPage(model)]),
      ),
    );
  }
}
