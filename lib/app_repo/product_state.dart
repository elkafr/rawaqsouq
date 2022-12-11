import 'package:flutter/material.dart';
import 'package:rawaqsouq/models/option.dart';

class ProductState extends ChangeNotifier {
  String _productId;

  void setProductId(String productId) {
    _productId = productId;
    notifyListeners();
  }

  String get productId => _productId;



  String _productTitle;

  void setProductTitle(String title) {
    _productTitle = title;
    notifyListeners();
  }

  String get productTitle => _productTitle;

//السعر

  int _productPrice;

  void setProductPrice(int productPrice) {
    _productPrice = productPrice;
    notifyListeners();
  }

  int get productPrice => _productPrice;



// العدد
  int _totalNumber = 1;

  void increaseTotalNumber() {
    _totalNumber++;
    notifyListeners();
  }




  void decreaseTotalNumber() {
    _totalNumber--;
    notifyListeners();
  }

  int get totalNumber => _totalNumber;





// الكارت
  int _totalCart = 0;

  void increaseTotalCart() {
    _totalCart++;
    notifyListeners();
  }

  void zeroCart() {
    _totalCart=0;
    notifyListeners();
  }

  int get totalCart => _totalCart;



// قائمة الحجم
  List<Option> _sizeList;

  void setSizeList(List<Option> sizeList) {
    _sizeList = sizeList;
  }

  List<Option> get sizeList => _sizeList;

  Option _lastSelectedSize;

  void setLastSelectedSize(Option option) {
    _lastSelectedSize = option;
    notifyListeners();
  }

  Option get lastSelectedSize => _lastSelectedSize;

  void updateChangesOnSizeList(int index) {
    _lastSelectedSize.isSelected = false;
    _sizeList[index].isSelected = true;
    _lastSelectedSize = _sizeList[index];
    notifyListeners();
  }

// التقطيع

  List<Option> _choppingList;

  void setChoppingList(List<Option> choppingList) {
    _choppingList = choppingList;
  }

  List<Option> get choppingList => _choppingList;

  Option _lastSelectedChopping;

  void setLastSelectedChopping(Option option) {
    _lastSelectedChopping = option;
    notifyListeners();
  }

  Option get lastSelectedChopping => _lastSelectedChopping;

  void updateChangesOnChoppingList(int index) {
    _lastSelectedChopping.isSelected = false;
    _choppingList[index].isSelected = true;
    _lastSelectedChopping = _choppingList[index];
    notifyListeners();
  }

  // التغليف

  List<Option> _encapsulationList;

  void setEncapsulationList(List<Option> encapsulationList) {
    _encapsulationList = encapsulationList;
  }

  List<Option> get encapsulationList => _encapsulationList;

  Option _lastSelectedEncapsulation;

  void setLastSelectedEncapsulation(Option option) {
    _lastSelectedEncapsulation = option;
    notifyListeners();
  }

  Option get lastSelectedEncapsulation => _lastSelectedEncapsulation;

  void updateChangesOnEncapsulationList(int index) {
    _lastSelectedEncapsulation.isSelected = false;
    _encapsulationList[index].isSelected = true;
    _lastSelectedEncapsulation = _encapsulationList[index];
    notifyListeners();
  }

  // الرأس والمقادم

  List<Option> _headAndSeatList;

  void setHeadAndSeatList(List<Option> headAndSeatList) {
    _headAndSeatList = headAndSeatList;
  }

  List<Option> get headAndSeatList => _headAndSeatList;

  Option _lastSelectedHeadAndSeat;

  void setLastSelectedHeadAndSeat(Option option) {
    _lastSelectedHeadAndSeat = option;
    notifyListeners();
  }

  Option get lastSelectedHeadAndSeat => _lastSelectedHeadAndSeat;

  void updateChangesOnHeadAndSeatList(int index) {
    _lastSelectedHeadAndSeat.isSelected = false;
    _headAndSeatList[index].isSelected = true;
    _lastSelectedHeadAndSeat = _headAndSeatList[index];
    notifyListeners();
  }

  // الكرش والمصران

  List<Option> _rumenAndInsistenceList;

  void setRumenAndInsistenceList(List<Option> rumenAndInsistenceList) {
    _rumenAndInsistenceList = rumenAndInsistenceList;
  }

  List<Option> get rumenAndInsistenceList => _rumenAndInsistenceList;

  Option _lastSelectedRumenAndInsistence;

  void setLastSelectedRumenAndInsistence(Option option) {
    _lastSelectedRumenAndInsistence = option;
    notifyListeners();
  }

  Option get lastSelectedRumenAndInsistence => _lastSelectedRumenAndInsistence;

  void updateChangesOnRumenAndInsistenceList(int index) {
    _lastSelectedRumenAndInsistence.isSelected = false;
    _rumenAndInsistenceList[index].isSelected = true;
    _lastSelectedRumenAndInsistence = _rumenAndInsistenceList[index];
    notifyListeners();
  }




// التكلفة النهائية
  int _totalCost = 0;

  void setTotalCost( int cost) {
    _totalCost = cost;
  }

  void updateTotalCost() {
    _totalCost = _productPrice * _totalNumber;
    notifyListeners();
  }

  int get totalCost => _totalCost;


//  String _userAddress;

//   void setUserAddress(String address) {
//   _userAddress = address;

// }

// void updateUserAddress(String address) {
//   _userAddress = address;
//   notifyListeners();
// }

// String get userAddress => _userAddress;
}
