import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/navigation_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/no_data/no_data.dart';
import 'package:rawaqsouq/components/not_registered/not_registered.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/models/cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double _height, _width;
  ProgressIndicatorState _progressIndicatorState;
  NavigationState _navigationState;
  AppState _appState;
  int _totalPrice = 0, _totalAmount = 0;
  Services _services = Services();
  bool _initialRun = true;
  Future<List<CartItem>> _cartList;
  bool _enableToBuy = false;

  Future<List<CartItem>> _getCartItems() async {
    Map<String, dynamic> results = await _services.get(
        'https://works.rawa8.com/apps/souq/api/last_cart?user_id=${_appState.currentUser.userId}&lang=${_appState.currentLang}');
    List<CartItem> cartList = List<CartItem>();
    if (results['response'] == '1') {
      Iterable iterable = results['ads'];
      cartList = iterable.map((model) => CartItem.fromJson(model)).toList();
      if (cartList.length > 0) {
        _enableToBuy = true;
      }

      setState(() {
        for (int i = 0; i < cartList.length; i++) {
          _totalPrice += cartList[i].price;
          _totalAmount += cartList[i].cartAmount;
        }
      });

      print('cart amount :$_totalAmount');
    } else {
      print('error');
    }
    return cartList;
  }

  Widget _buildCartList() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<CartItem>>(
          future: _cartList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0,
                                            color: Color(0xffEBEBEB)),
                                        color: cWhite,
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        )),
                                    child: Image.network(
                                      snapshot.data[index].adsMtgerPhoto,
                                      height: constraints.maxHeight * 0.25,
                                      width: constraints.maxWidth * 0.25,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: _width * 0.5,
                                        margin:
                                            EdgeInsets.only(top: 10, bottom: 5),
                                        child: Text(
                                          snapshot.data[index].title,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.035,
                                      ),
                                      // Image.asset(
                                      //   'assets/images/logo.png',
                                      //   height: constraints.maxHeight * 0.1,
                                      //   width: constraints.maxWidth * 0.1,
                                      // ),
                                      Container(
                                        height: _height * 0.05,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .amount,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            FloatingActionButton(
                                              elevation: 0,
                                              backgroundColor: cWhite,
                                              heroTag: 'btn $index',
                                              child: Icon(
                                                FontAwesomeIcons.plus,
                                                color: cPrimaryColor,
                                                size: 15,
                                              ),
                                              onPressed: () async {
                                                print('amount');
                                                setState(() {
                                                  snapshot
                                                      .data[index].cartAmount++;
                                                  _totalAmount++;
                                                  _totalPrice = _totalPrice +
                                                      snapshot.data[index]
                                                          .cartPrice;
                                                });
                                                await _services.get(
                                                    'https://works.rawa8.com/apps/souq/api/updateAmount?cart_amount=${snapshot.data[index].cartAmount}&cart_id=${snapshot.data[index].cartId}');
                                              },
                                            ),
                                            Container(
                                              width: 25,
                                              height: 25,
                                              child: Center(
                                                child: Text(
                                                  snapshot
                                                      .data[index].cartAmount
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: cPrimaryColor,
                                                  border: Border.all(
                                                      color: cPrimaryColor,
                                                      width: 1.0),
                                                  shape: BoxShape.circle),
                                            ),
                                            FloatingActionButton(
                                              elevation: 0,
                                              backgroundColor: cWhite,
                                              heroTag: 'btn1 $index',
                                              child: Icon(
                                                FontAwesomeIcons.minus,
                                                color: cPrimaryColor,
                                                size: 15,
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  if (snapshot.data[index]
                                                          .cartAmount >
                                                      0) {
                                                    snapshot.data[index]
                                                        .cartAmount--;
                                                    _totalAmount--;
                                                    _totalPrice = _totalPrice -
                                                        snapshot.data[index]
                                                            .cartPrice;
                                                  }
                                                });
                                                if (snapshot.data[index]
                                                        .cartAmount >
                                                    0) {
                                                  await _services.get(
                                                      'https://works.rawa8.com/apps/souq/api/updateAmount?cart_amount=${snapshot.data[index].cartAmount}&cart_id=${snapshot.data[index].cartId}');
                                                }
                                              },
                                            ),
                                            Text(
                                              '${snapshot.data[index].cartPrice.toString()} ${AppLocalizations.of(context).sr}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                          Positioned(
                            left: _appState.currentLang == 'ar'
                                ? 0
                                : constraints.maxWidth * 0.8,
                            right: _appState.currentLang != 'ar'
                                ? 0
                                : constraints.maxWidth * 0.8,
                            top: 0,
                            child: GestureDetector(
                                onTap: () async {
                                  _progressIndicatorState.setIsLoading(true);
                                  var results = await _services.get(
                                      'https://works.rawa8.com/apps/souq/api/delete_cart?user_id=${_appState.currentUser.userId}&cart_id=${snapshot.data[index].cartId}&lang=${_appState.currentLang}');
                                  _progressIndicatorState.setIsLoading(false);
                                  if (results['response'] == '1') {
                                    showToast(results['message'], context);
                                    _navigationState.upadateNavigationIndex(3);
                                    Navigator.pushReplacementNamed(
                                        context, '/navigation');
                                  } else {
                                    showErrorDialog(
                                        results['message'], context);
                                  }
                                },
                                child: Image.asset('assets/images/delete.png')),
                          )
                        ],
                      );
                    });
              } else {
                return NoData(
                    message: AppLocalizations.of(context).noResultIntoCart);
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(
                child: SpinKitSquareCircle(color: cPrimaryColor, size: 25));
          });
    });
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
            height: _height,
            width: _width,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: _height * 0.1,
                ),
                Expanded(
                    child: Container(
                  color: cWhite,
                  width: _width,
                  // height: _height * 0.65,
                  child: _buildCartList(),
                )),
                Container(
                  height: _height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context).productsNo,
                          style: TextStyle(
                              color: cBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          _totalAmount.toString(),
                          style: TextStyle(
                              color: cPrimaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<CartItem>>(
                    future: _cartList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            height: _height * 0.06,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Text(
                                    AppLocalizations.of(context).totalPrice,
                                    style: TextStyle(
                                      color: cBlack,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'segoeui',
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: cPrimaryColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'segoeui',
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text:
                                                  '${_totalPrice.toString()}'),
                                          new TextSpan(
                                              text: AppLocalizations.of(context)
                                                  .sr,
                                              style: new TextStyle(
                                                color: cPrimaryColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                fontFamily: 'segoeui',
                                              )),
                                        ],
                                      ),
                                    )),
                              ],
                            ));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return Center(
                          child: SpinKitSquareCircle(
                              color: cPrimaryColor, size: 25));
                    }),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Divider()),
                Center(
                  child: Text(
                    AppLocalizations.of(context).applicationValue,
                    style: TextStyle(color: Color(0xffC5C5C5), fontSize: 12),
                  ),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 60,
                    child: CustomButton(
                        btnLbl: AppLocalizations.of(context).completePurchase,
                        onPressedFunction: () async {
                          if (_enableToBuy) {
                            _progressIndicatorState.setIsLoading(true);
                            var results = await _services.get(
                                'https://works.rawa8.com/apps/souq/api/cash?user_id=${_appState.currentUser.userId}&lang=${_appState.currentLang}');
                            _progressIndicatorState.setIsLoading(false);
                            if (results['response'] == '1') {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                  ),
                                  context: context,
                                  builder: (builder) {
                                    return Container(
                                      height: _height * 0.25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                              'assets/images/check.png'),
                                          Text(
                                            AppLocalizations.of(context)
                                                .purchaseRequestHasSentSuccessfully,
                                            style: TextStyle(
                                                color: cBlack,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                              Future.delayed(const Duration(seconds: 1), () {
                                _navigationState.upadateNavigationIndex(1);
                                Navigator.pushNamed(context, '/navigation');
                              });
                            } else {
                              showErrorDialog(results['message'], context);
                            }
                          } else {
                            showToast(
                                AppLocalizations.of(context).noResultIntoCart,
                                context);
                          }
                        }))
              ],
            )));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _initialRun = false;
      _appState = Provider.of<AppState>(context);
      if (_appState.currentUser != null) {
        _cartList = _getCartItems();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _navigationState = Provider.of<NavigationState>(context);
    return NetworkIndicator(
        child: PageContainer(
      child: Scaffold(
          backgroundColor: Color(0xffF5F2F2),
          body: Stack(
            children: <Widget>[
              Consumer<AppState>(builder: (context, appState, child) {
                return appState.currentUser != null
                    ? _buildBodyItem()
                    : NotRegistered();
              }),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GradientAppBar(
                  appBarTitle: AppLocalizations.of(context).cart,
                  trailing: IconButton(
                    icon: Icon(
                      Icons.notifications_active,
                      color: cWhite,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications_screen');
                    },
                  ),
                ),
              ),
              Center(
                child: ProgressIndicatorComponent(),
              )
            ],
          )),
    ));
  }
}
