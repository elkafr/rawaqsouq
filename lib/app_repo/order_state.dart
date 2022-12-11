import 'package:flutter/material.dart';



class OrderState extends ChangeNotifier {




   String _carttFatora;

  void setCarttFatora(String carttFatora) {
    _carttFatora = carttFatora;
    notifyListeners();
  }

  String get carttFatora => _carttFatora;



}