import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: const Text("Ovid's Shop"),
      ),
      body: ProductsGrid(),
    );
    return scaffold;
  }
}

