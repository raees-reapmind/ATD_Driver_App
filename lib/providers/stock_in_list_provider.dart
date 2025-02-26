import 'package:flutter/material.dart';

import '../models/product.dart';

class StockInListProvider with ChangeNotifier{
  List<Product> _list = [
    Product(id: 1, name: "Lubricant", custody: "Vashi Retail Outlet", quantity: 4),
    Product(id: 2, name: "Jerry Can", custody: "Nerul Retail Outlet", quantity: 7),
    Product(id: 1, name: "Lubricant", custody: "Nerul Retail Outlet", quantity: 2),
  ];

  List<Product> get list => _list;

  set list(List<Product> value) {
    _list = value;
    notifyListeners();
  }
}