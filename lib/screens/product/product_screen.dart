import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/navigation_state.dart';
import 'package:rawaqsouq/components/app_repo/product_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/horizontal_divider/horizontal_divider.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/product_details.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double _height, _width;
  ProgressIndicatorState _progressIndicatorState;
  ProductState _productState;
  bool _initialRun = true;
  Services _services = Services();
  Future<ProductDetails> _productDetails;
  AppState _appState;
  NavigationState _navigationState;

  Future<ProductDetails> _getProductDetails() async {
    Map<String, dynamic> results = await _services.get(
        'https://works.rawa8.com/apps/souq/api/show_mtger_ads?lang=${_appState.currentLang}&id=${_productState.currentProduct.adsMtgerId}');
    ProductDetails productDetails = ProductDetails();
    if (results['response'] == '1') {
      productDetails = ProductDetails.fromJson(results['details']);
    } else {
      print('error');
    }
    return productDetails;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _productState = Provider.of<ProductState>(context);
      _appState = Provider.of<AppState>(context);
      _productDetails = _getProductDetails();
      _initialRun = false;
    }
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Container(
          height: _height,
          child: FutureBuilder<ProductDetails>(
              future: _productDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Color(0xffF5F2F2),
                        height: _height * 0.35,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: _height * 0.05),
                          child: Image.network(
                            _productState.currentProduct.adsMtgerPhoto,
                            height: _height * 0.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          snapshot.data.adsMtgerName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10, bottom: 5 ,left: 10),
                            child: Image.asset(
                              'assets/images/wheatsm.png',
                              color: cLightLemon,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 5,
                              left: 5
                            ),
                            child: Text(
                              snapshot.data.adsMtgerCat,
                              style: TextStyle(
                                  color: cLightLemon,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Text(
                          AppLocalizations.of(context).productDetails,
                          style: TextStyle(
                              fontSize: 16,
                              color: cPrimaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Text(
                         AppLocalizations.of(context).allProductDetails,
                          style:
                              TextStyle(color: Color(0xffC5C5C5), fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                        child: Text(
                          snapshot.data.adsMtgerContent,
                          style: TextStyle(color: cBlack, fontSize: 15),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                             colors: [ Color(0xff1532C2),Color(0xff0083D3),],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(
                                      right: 5,
                                      left: 5
                                    ),
                                    child: Text(
                                      snapshot.data.adsMtgerPrice,
                                      style: TextStyle(
                                        fontSize: 14,
                                          color: cWhite,
                                          fontWeight: FontWeight.w700),
                                    )),
                                Container(
                                  child: Text(
                                    AppLocalizations.of(context).sr,
                                    style: TextStyle(
                                        color: cWhite,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 7),
                              width: 1,
                              height: _height * 0.17,
                              color: cWhite,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_appState.currentUser != null) {
                                  _progressIndicatorState.setIsLoading(true);
                                  var results = await _services.get(
                                    'https://works.rawa8.com/apps/souq/api/add_cart?user_id=${_appState.currentUser.userId}&ads_id=${_productState.currentProduct.adsMtgerId}&amountt=1&lang=${_appState.currentLang}',
                                  );
                                  _progressIndicatorState.setIsLoading(false);
                                  if (results['response'] == '1') {
                                    showToast(results['message'], context);
                                    _navigationState.upadateNavigationIndex(3);
                                    Navigator.pushNamed(context, '/navigation');
                                  } else {
                                    showErrorDialog(
                                        results['message'], context);
                                  }
                                } else {
                                  Navigator.pushNamed(context, '/login_screen');
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(
                                        right: 5,
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: cWhite,
                                      )),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    child: Text(
                                    AppLocalizations.of(context).addToCart,
                                      style: TextStyle(
                                          color: cWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(
                    child: SpinKitThreeBounce(
                  color: cPrimaryColor,
                  size: 40,
                ));
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _navigationState = Provider.of<NavigationState>(context);
    return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientAppBar(
                appBarTitle: _productState.currentProduct.adsMtgerName,
                  leading: _appState.currentLang == 'ar' ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: cWhite,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ) :Container(),
              trailing: _appState.currentLang == 'en' ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: cWhite,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ) :Container()),
          ),
          Center(
            child: ProgressIndicatorComponent(),
          )
        ],
      )),
    ));
  }
}
