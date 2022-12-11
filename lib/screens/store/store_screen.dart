import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/navigation_state.dart';
import 'package:rawaqsouq/components/app_repo/product_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/no_data/no_data.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/category.dart';
import 'package:rawaqsouq/models/product.dart';
import 'package:rawaqsouq/screens/store/components/store_appbar.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/components/app_repo/store_state.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _initialRun = true;
  double _height, _width;
  StoreState _storeState;
  AppState _appState;
  ProductState _productState;
  Services _services = Services();
  Future<List<Category>> _categoriesList;
  Future<List<Product>> _productList;
  ProgressIndicatorState _progressIndicatorState;
  NavigationState _navigationState;

  Future<List<Category>> _getCategories() async {
    Map<String, dynamic> results = await _services.get(
        'https://works.rawa8.com/apps/souq/api/show_mtger_cats?id=${_storeState.currentStore.mtgerId}&lang=${_appState.currentLang}');
    List categoryList = List<Category>();
    if (results['response'] == '1') {
      Iterable iterable = results['cat'];
      categoryList = iterable.map((model) => Category.fromJson(model)).toList();
      if (categoryList.length > 0) {
        categoryList[0].isSelected = true;
      }
    } else {
      print('error');
    }
    return categoryList;
  }

  Future<List<Product>> _getProducts(String categoryId) async {
    Map<String, dynamic> results = await _services.get(
        'https://works.rawa8.com/apps/souq/api/show_mtgerr?lang=${_appState.currentLang}&page=1&mtger_id=${_storeState.currentStore.mtgerId}&cat_id=$categoryId');
    List<Product> productList = List<Product>();
    if (results['response'] == '1') {
      Iterable iterable = results['results'];
      productList = iterable.map((model) => Product.fromJson(model)).toList();
    } else {
      print('error');
    }
    return productList;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _storeState = Provider.of<StoreState>(context);
      _appState = Provider.of<AppState>(context);
      _productState = Provider.of<ProductState>(context);
      _categoriesList = _getCategories();
      _productList = _getProducts('0');
      _initialRun = false;
    }
  }

  Widget _buildCategoriesList() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Category>>(
        future: _categoriesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
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
                            _productList =
                                _getProducts(snapshot.data[index].mtgerCatId);
                        
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
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.network(
                                    snapshot.data[index].mtgerCatPhoto,
                                    height: 15,
                                    color: snapshot.data[index].isSelected
                                        ? cWhite
                                        : cLightLemon,
                                    width: 18,
                                  )),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5 ),
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
            } else {
              return Center(child: Text(AppLocalizations.of(context).noDepartments));
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
              child: SpinKitSquareCircle(color: cPrimaryColor, size: 25));
        },
      );
    });
  }

  Widget _buildProducts() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _productState.setCurrentProduct(snapshot.data[index]);

                          Navigator.pushNamed(context, '/product_screen');
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10,
                              left: 12,
                              right: 12,
                              bottom:
                                  index == snapshot.data.length - 1 ? 20 : 0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: Color(0xffEBEBEB)),
                              color: cWhite,
                              borderRadius: BorderRadius.circular(
                                10.0,
                              )),
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: 10, right: 10 ,left: 10),
                                    child: Text(
                                      snapshot.data[index].adsMtgerName,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 10,
                                            right: 10, bottom: 5),
                                        child: Image.asset(
                                          'assets/images/wheatsm.png',
                                          color: cLightLemon,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: 5,left: 5
                                        ),
                                        child: Text(
                                          snapshot.data[index].adsMtgerCat,
                                          style: TextStyle(
                                              color: cLightLemon,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(
                                            right: 10, left: 10,
                                          ),
                                          child: Text(
                                            snapshot.data[index].adsMtgerPrice,
                                            style: TextStyle(
                                                color: cPrimaryColor,
                                                fontWeight: FontWeight.w700),
                                          )),
                                      Container(
                                        child: Text(
                                         AppLocalizations.of(context).sr,
                                          style: TextStyle(
                                              color: cPrimaryColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5,left: 5),
                                    width: _width * 0.35,
                                    height: 50,
                                    child: CustomButton(
                                      btnStyle: TextStyle(
                                          color: cWhite, fontSize: 13),
                                      prefixIcon: Icon(
                                        Icons.shopping_cart,
                                        color: cWhite,
                                      ),
                                      btnLbl: AppLocalizations.of(context).addToCart,
                                      onPressedFunction: () async {
                                        if (_appState.currentUser != null) {
                                          _progressIndicatorState
                                              .setIsLoading(true);
                                          var results = await _services.get(
                                            'https://works.rawa8.com/apps/souq/api/add_cart?user_id=${_appState.currentUser.userId}&ads_id=${snapshot.data[index].adsMtgerId}&amountt=1&lang=${_appState.currentLang}',
                                          );
                                          _progressIndicatorState
                                              .setIsLoading(false);
                                          if (results['response'] == '1') {
                                            showToast(
                                                results['message'], context);
                                          
                                          } else {
                                            showErrorDialog(
                                                results['message'], context);
                                          }
                                        } else {
                                          Navigator.pushNamed(
                                              context, '/login_screen');
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              Container(
                                 padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Color(0xffEBEBEB)),
                                    color: Color(0xffF5F2F2),
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    )),
                                child: Image.network(
                                  snapshot.data[index].adsMtgerPhoto,
                                  width:
                                      100,
                                ),
                              )
                            ],
                          ),
                        ));
                  });
            } else {
              return NoData(
                message: AppLocalizations.of(context).noResults
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
          height: _height * 0.25,
        ),
        Container(width: _width, height: 50, child: _buildCategoriesList()),
        Container(
          margin: EdgeInsets.only(bottom: 7),
          height: _height * 0.65,
          child: _buildProducts(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _navigationState = Provider.of<NavigationState>(context);
    return NetworkIndicator( child:PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Positioned(top: 0, left: 0, right: 0, child: StoreAppBar()),
          Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width * 0.5 - 40,
              child:
                  Consumer<StoreState>(builder: (context, storeState, child) {
    
              return
                 Container(
                  width: 80,
                  height: 80,
              
                    decoration: new BoxDecoration(
                        border:
                            Border.all(color: Color(0xff1F61301A), width: 1.0),
                        shape: BoxShape.circle,
                        image:  DecorationImage(
                              fit: BoxFit.fill,
                            image: new NetworkImage(
                              storeState.currentStore.adsPhoto,
                            ))));
     
              })),
          Center(
            child: ProgressIndicatorComponent(),
          )
        ],
      )),
    ));
  }
}
