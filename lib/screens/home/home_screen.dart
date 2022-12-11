import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_data/shared_preferences_helper.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/custom_text_form_field/custom_text_form_field.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/no_data/no_data.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/models/category.dart';
import 'package:rawaqsouq/models/store.dart';
import 'package:rawaqsouq/utils/utils.dart';
import 'package:rawaqsouq/components/app_repo/store_state.dart';
import 'package:rawaqsouq/components/store_card/store_card_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _height;
  double _width;
  Future<List<Category>> _categoriesList;
  Future<List<Store>> _storeList;
  Services _services = Services();
  bool _enableSearch = false;
  String _categoryId = '1';
  StoreState _storeState;
  AppState _appState;
  bool _initialRun = true;
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
       FlutterLocalNotificationsPlugin();

       void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }


 void _firebaseCloudMessagingListeners() {

    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(platform);
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('newToken: $newToken');
                await _services.get(
                                  'https://works.rawa8.com/apps/souq/api/push?user_id=${_appState.currentUser.userId}&token=$newToken');
    });
    if (Platform.isIOS) _iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(message);
      
      },

      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        Navigator.pushNamed(context, '/notifications_screen');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        Navigator.pushNamed(context, '/notifications_screen');
      },
    );
  }

  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }

  Future<List<Category>> _getCategories() async {
    String language =  await SharedPreferencesHelper.getUserLang();
    Map<String, dynamic> results = await _services.get(Utils.CATEGORIES_URL+ language);
    List categoryList = List<Category>();
    if (results['response'] == '1') {
      Iterable iterable = results['city'];
      categoryList = iterable.map((model) => Category.fromJson(model)).toList();
      categoryList[0].isSelected = true;
    } else {
      print('error');
    }
    return categoryList;
  }

  Future<List<Store>> _getStores(String specificCategory) async {
    Map<String, dynamic> results =
        await _services.get(Utils.BASE_URL + specificCategory);
    List<Store> storeList = List<Store>();
    if (results['response'] == '1') {
      Iterable iterable = results['results'];
      storeList = iterable.map((model) => Store.fromJson(model)).toList();
      if (_appState.currentUser != null) {
// app favourite list on consume on it
        for (int i = 0; i < storeList.length; i++) {
          print('id: ${storeList[i].mtgerId} : favourite ${storeList[i].isAddToFav}');
          _storeState.setIsFavourite(
              storeList[i].mtgerId, storeList[i].isAddToFav);
        }
      }
    } else {
      print('error');
    }
    return storeList;
  }

  Widget _buildCategoriesList() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Category>>(
        future: _categoriesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          for (int i = 0; i < snapshot.data.length; i++) {
                            snapshot.data[i].isSelected = false;
                          }
                          snapshot.data[index].isSelected = true;
                          if (index == 0) {
                            if (_appState.currentUser != null) {
                              _storeList = _getStores(
                                  'show_mtager_cat?page=1&lang=${_appState.currentLang}&user_id=${_appState.currentUser.userId}');
                            } else {
                              _storeList =
                                  _getStores('show_mtager_cat?page=1&lang=${_appState.currentLang}');
                            }
                            _categoryId = '1';
                          } else {
                            if (_appState.currentUser != null) {
                              _storeList = _getStores(
                                  'show_mtager_cat_filter?lang=${_appState.currentLang}&page=1&cat=${snapshot.data[index].mtgerCatId}&user_id=${_appState.currentUser.userId}');
                            } else {
                              _storeList = _getStores(
                                  'show_mtager_cat_filter?lang=${_appState.currentLang}&page=1&cat=${snapshot.data[index].mtgerCatId}');
                            }

                            _categoryId = snapshot.data[index].mtgerCatId;
                          }
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                        decoration: BoxDecoration(
                          color: snapshot.data[index].isSelected
                              ? cLightLemon
                              : cWhite,
                          borderRadius: snapshot.data[index].isSelected
                              ? BorderRadius.circular(15.0)
                              : BorderRadius.circular(0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Image.network(
                                  snapshot.data[index].mtgerCatPhoto,
                                  height: 15,
                                  color: snapshot.data[index].isSelected
                                      ? cWhite
                                      : cLightLemon,
                                  width: 18,
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 5,right: 5),
                                child: Text(
                                  snapshot.data[index].mtgerCatName,
                                  style: TextStyle(
                                      color: snapshot.data[index].isSelected
                                          ? cWhite
                                          : cBlack,
                                      fontSize: 12),
                                ))
                          ],
                        ),
                      ));
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
              child: SpinKitSquareCircle(color: cPrimaryColor, size: 25));
        },
      );
    });
  }

  Widget _buildStoresOfCategory() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Store>>(
        future: _storeList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _storeState.setCurrentStore(snapshot.data[index]);
                          Navigator.pushNamed(context, '/store_screen');
                        },
                        child:  Container(
                          height: constraints.maxHeight * 0.18,
                          margin:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                          decoration: BoxDecoration(
                              color: cWhite,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: StoreCardItem(
                            store: snapshot.data[index],
                          ),
                        )
                        );
                  });
            } else {
              return NoData(
                message: AppLocalizations.of(context).noResults,
              );
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
              child: SpinKitThreeBounce(
            color: cPrimaryColor,
            size: 40,
          ));
        },
      );
    });
  }


  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Container(
            color: cWhite,
            width: _width,
            height: 50,
            child: _buildCategoriesList()),
        Container(
            margin: EdgeInsets.only(top: 7, bottom: 200),
            height: _height - 100,
            child: _buildStoresOfCategory())
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _initialRun = false;
      _appState = Provider.of<AppState>(context);
       
      if (_appState.currentUser != null) {
           _firebaseCloudMessagingListeners();
            
        _storeList = _getStores(
            'show_mtager_cat?page=1&lang=${_appState.currentLang}&user_id=${_appState.currentUser.userId}');
      } else {
        _storeList = _getStores('show_mtager_cat?page=1&lang=${_appState.currentLang}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
     _categoriesList = _getCategories();

  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _storeState = Provider.of<StoreState>(context);

    return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),
              _enableSearch
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                          colors: [ Color(0xff9BD427),Color(0xff247E48),],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: cWhite,
                            borderRadius: BorderRadius.circular(23.0)),
                        child: TextFormField(
                            cursorColor: Color(0xffC5C5C5),
                            maxLines: 1,
                            onChanged: (text) {
                              print(text);
                              setState(() {
                                if (_categoryId == '1') {
                                  _storeList = _getStores(
                                      'search111?page=1&lang=${_appState.currentLang}&title=$text');
                                  print('1111111111');
                                } else {
                                  _storeList = _getStores(
                                      'search222?lang=${_appState.currentLang}&page=1&cat=$_categoryId&title=$text');
                                  print('cate id :$_categoryId');
                                }
                              });
                            },
                            style: TextStyle(
                                color: cBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23.0),
                                borderSide:
                                    BorderSide(color: Color(0xffC5C5C5)),
                              ),
                              focusColor: Color(0xffC5C5C5),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffC5C5C5)),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Color(0xffC5C5C5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _enableSearch = false;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 24,
                                color: Color(0xffC5C5C5),
                              ),
                              hintText: AppLocalizations.of(context).search,
                              errorStyle: TextStyle(fontSize: 12.0),
                              hintStyle: TextStyle(
                                  color: Color(0xffC5C5C5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )),
                      ))
                  : Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: GradientAppBar(
                        appBarTitle: AppLocalizations.of(context).aouonTuraif,
                        leading: _appState.currentLang == 'ar'  ? IconButton(
                          icon: Icon(Icons.search, color: cWhite),
                          onPressed: () {
                            setState(() {
                              _enableSearch = true;
                            });
                          },
                        ) : IconButton(
                          icon: Icon(
                            Icons.notifications_active,
                            color: cWhite,
                          ),
                          onPressed: () {
                          Navigator.pushNamed(context, '/notifications_screen');
                          },
                        ),
                        trailing:  _appState.currentLang == 'ar'? IconButton(
                          icon: Icon(
                            Icons.notifications_active,
                            color: cWhite,
                          ),
                          onPressed: () {
                          Navigator.pushNamed(context, '/notifications_screen');
                          },
                        ) : IconButton(
                          icon: Icon(Icons.search, color: cWhite),
                          onPressed: () {
                            setState(() {
                              _enableSearch = true;
                            });
                          },
                        ),
                      ) ,
                    ),
            ],
          )),
    ));
  }
}
