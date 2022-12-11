import 'package:flutter/material.dart';
import 'package:rawaqsouq/models/city.dart';
import 'package:rawaqsouq/models/user.dart';



class AppState extends ChangeNotifier {
  User _currentUser;
  void setCurrentUser(User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  User get currentUser => _currentUser;



 bool _acceptTerms = false;

  void setAcceptTerms(bool acceptTerms) {
    _acceptTerms = acceptTerms;
    notifyListeners();
  }

  bool get acceptTerms => _acceptTerms;

 void  updateUserEmail(String newUserEmail){
   _currentUser.userEmail = newUserEmail;
   notifyListeners();
 }

 void  updateUserPhone(String newUserPhone){
   _currentUser.userPhone = newUserPhone;
   notifyListeners();
 }

  void  updateUserName(String newUserName){
   _currentUser.userName = newUserName;
   notifyListeners();
 }

   void  updateUserCity(City newUserCity){
   _currentUser.userCity = newUserCity;
   notifyListeners();
 }

  // current language from shared prefernces 'ar' or 'en'
  String _currentLang;
  
 void setCurrentLanguage(String currentLang) {
    _currentLang = currentLang;
    notifyListeners();
  }

  String get currentLang => _currentLang;

}
