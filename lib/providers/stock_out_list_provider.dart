import 'package:flutter/material.dart';

import '../models/product.dart';

class StockOutListProvider with ChangeNotifier{
  List<Product> _list = [
    Product(id: 1, name: "Lubricant", custody: "Your Stock", quantity: 20),
    Product(id: 2, name: "Jerry Can", custody: "Your Stock", quantity: 6),
  ];

  List<Product> get list => _list;

  set list(List<Product> value) {
    _list = value;
    notifyListeners();
  }
}