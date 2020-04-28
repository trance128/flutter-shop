import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  String authToken;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> addProduct(Product prod) async {
    print("Starting add product");
    final url =
        "https://flutter-shop-621a8.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': prod.title,
            'description': prod.description,
            'imageUrl': prod.imageUrl,
            'price': prod.price,
            'isFavorite': prod.isFavorite,
          },
        ),
      );
      print(json.decode(response.body)['name']);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: prod.title,
        price: prod.price,
        description: prod.description,
        imageUrl: prod.imageUrl,
      );

      _items.insert(0, newProduct);
      notifyListeners();
      print("Added successfully, notifying listeners");
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://flutter-shop-621a8.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print(
          "Something has gone wrong.\nThe system thinks you're editing a product which doesn't exist");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://flutter-shop-621a8.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProductIndex = _items.indexWhere((item) => item.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        throw HttpException("Something went wrong");
      }
      existingProduct = null;
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        "https://flutter-shop-621a8.firebaseio.com/products.json?auth=$authToken";

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (extractedData == null) {
        return;
      }

      extractedData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: prodData['isFavorite'],
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
