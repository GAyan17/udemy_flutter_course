import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scoped_models/main_model.dart';
import './models/product.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthentication();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  Widget _buildMaterialApp(MainModel model) {
    return MaterialApp(
      //debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.blue,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrangeAccent),
      //home: AuthPage(),
      routes: {
        '/': (BuildContext context) =>
            !_isAuthenticated ? AuthPage() : ProductsPage(_model),
        '/productspage': (BuildContext context) => ProductsPage(model),
        '/admin': (BuildContext context) => ProductAdminPage(model)
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final String productId = pathElements[2];
          final Product product =
              model.allProducts.firstWhere((Product product) {
            return product.id == productId;
          });
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(product),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(model));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: _buildMaterialApp(_model),
    );
  }
}
