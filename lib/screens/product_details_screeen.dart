import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    return Center(
      child: Text(
        productId,
        textAlign: TextAlign.center,
      ),
    );
  }
}
