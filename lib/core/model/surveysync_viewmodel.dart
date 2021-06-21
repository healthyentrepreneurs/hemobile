import 'package:flutter/cupertino.dart';

class SurveySyncViewModel extends ChangeNotifier{
  int _counter = 0;
  int get counter => _counter;
  void increment() {
    _counter++;
    notifyListeners();                          // <-- notify listeners
  }
}