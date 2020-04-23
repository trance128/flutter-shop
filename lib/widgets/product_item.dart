import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  // final String description;
  // final double price;
  // bool isFavorite;

  ProductItem(
    this.id,
    this.title,
    this.imageUrl,
    // this.description,
    // this.price,
    // this.isFavorite = false,
  );

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black26,
        leading: IconButton(
          icon: Icon(
            Icons.favorite,
          ),
          onPressed: () {},
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {},
        ),
      ),
    );
  }
}
