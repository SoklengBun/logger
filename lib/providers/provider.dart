import 'package:flutter/material.dart';

class ListProvider with ChangeNotifier {
  List<String> data = [];

  setList(String value) {
    if (data.length >= 200) {
      data.removeRange(0, 100);
    }

    data.add(value);
    notifyListeners();
  }
}
