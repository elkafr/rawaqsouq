import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_data/shared_preferences_helper.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppState _appState;
  Future initData() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Widget _buildBodyItem() {
    return Image.asset(
      'assets/images/splash.png',
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Future<void> _getLanguage() async {
    String currentLang = await SharedPreferencesHelper.getUserLang();
    _appState.setCurrentLanguage(currentLang);
    print('language: ${_appState.currentLang}');
  }

  Future<Null> _checkIsFirstTime() async {
    var _firstTime = await SharedPreferencesHelper.getFirstTime();
    if (_firstTime) {
      SharedPreferencesHelper.saveFirstTime(false);
   Navigator.pushReplacementNamed(context, '/navigation');
    } else {
      Navigator.pushReplacementNamed(context, '/navigation');
    }
  }

  @override
  void initState() {
    super.initState();
    _getLanguage();
    initData().then((value) { 
       _checkIsFirstTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);
    return PageContainer(
        child: Scaffold(
      body: _buildBodyItem(),
    ));
  }
}
