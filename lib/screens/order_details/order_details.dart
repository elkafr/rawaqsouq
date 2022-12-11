import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/navigation_state.dart';
import 'package:rawaqsouq/components/app_repo/order_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/app_repo/tab_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/order.dart';
import 'package:rawaqsouq/screens/order_details/edit_order_details.dart';
import 'package:rawaqsouq/screens/orders/components/cancel_order_bottom_sheet.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class OrderDetailsScreen extends StatefulWidget {



  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _initialRun = true;
  OrderState _orderState;
  double _height, _width;
  Services _services = Services();
  ProgressIndicatorState _progressIndicatorState;
  AppState _appState;
  TabState _tabState;
  NavigationState _navigationState;
  Future<Order> _orderDetails;

  Future<Order> _getOrderDetails() async {
    Map<String, dynamic> results = await _services.get(
        'https://works.rawa8.com/apps/souq/api/show_buy?lang=${_appState.currentLang}&user_id=${_appState.currentUser.userId}&cartt_fatora=${_orderState.carttFatora}&cartt_seller=${_orderState.carttSeller}');
    Order orderDetails = Order();
    if (results['response'] == '1') {
      orderDetails = Order.fromJson(results['result']);
    } else {
      print('error');
    }
    return orderDetails;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _initialRun = false;
      _appState = Provider.of<AppState>(context);
      _orderState = Provider.of<OrderState>(context);
      _orderDetails = _getOrderDetails();
    }
  }

  Widget _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: cBlack),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w400, color: cBlack))
        ],
      ),
    );
  }

  Widget _buildBodyItem(Order order) {
    return SingleChildScrollView(
      child: Container(
        width: _width,
        height: _height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Container(
                height: 50,
                child:
                    _buildRow(AppLocalizations.of(context).orderNo, order.carttNumber)),
            Container(
                color: Color(0xffFBF6F6),
                height: 50,
                child: _buildRow(AppLocalizations.of(context).store, order.carttMtger)),
            Container(
                height:50,
                child: _buildRow('${AppLocalizations.of(context).totalPrice}',
                    order.carttTotlal.toString())),
            Container(
                color: Color(0xffFBF6F6),
                height: 50,
                child:
                    _buildRow(AppLocalizations.of(context).orderDate, order.carttDate)),
            Container(
                height: 50,
                child: _buildRow(AppLocalizations.of(context).orderReceiptTime,
                    '${order.carttTawsilDate}  ${order.carttTawsilTime}')),
            Container(
                color: Color(0xffFBF6F6),
                height: 50,
                child:
                    _buildRow(AppLocalizations.of(context).orderStatus, order.carttState)),
            Container(
              margin: EdgeInsets.only(
                  left: _width * 0.04, right: _width * 0.04, top: _height * 0.025),
              height: _height * 0.05,
              child: Text(AppLocalizations.of(context).orderDetails,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400, color: cBlack)),
            ),
            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
              height: order.carttDetails.length > 2
                  ? _height * 0.2
                  : _height * 0.1,
              child: ListView.builder(
                  itemCount: order.carttDetails.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: _height * 0.02),
                      height: 50,
                      child: _buildRow(
                          order.carttDetails[index].carttName,
                          order.carttDetails[index].carttAmount
                              .toString()),
                    );
                  }),
            ),
            Spacer(),
            _orderState.isWaitingOrder ? Divider() : Container(),
            _orderState.isWaitingOrder
                ? Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 60,
                          width: _width * 0.5,
                          child: CustomButton(
                              btnStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: cWhite),
                              btnLbl: AppLocalizations.of(context).cancelOrder,
                              onPressedFunction: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    context: context,
                                    builder: (builder) {
                                      return Container(
                                        height: _height * 0.35,
                                        width: _width,
                                        child: CancelOrderBottomSheet(
                                          onPressedConfirmation: () async {
                                            _progressIndicatorState
                                                .setIsLoading(true);
                                            var results = await _services.get(
                                                'https://works.rawa8.com/apps/souq/api/do_dis_buy?cartt_fatora=${order.carttFatora}&cartt_seller=${order.carttSeller}&lang=${_appState.currentLang}');
                                            _progressIndicatorState
                                                .setIsLoading(false);
                                            if (results['response'] == '1') {
                                              showToast(
                                                  results['message'], context);
                                              Navigator.pop(context);
                                              _tabState.upadateInitialIndex(3);
                                              _navigationState
                                                  .upadateNavigationIndex(1);
                                              Navigator.pushReplacementNamed(
                                                  context, '/navigation');
                                            } else {
                                              showErrorDialog(
                                                  results['message'], context);
                                            }
                                          },
                                        ),
                                      );
                                    });
                              })),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 60,
                          width: _width * 0.5,
                          child: CustomButton(
                              btnStyle: TextStyle(
                                color: cPrimaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              hasGradientColor: false,
                              btnLbl: AppLocalizations.of(context).editOrder,
                              btnColor: cWhite,
                              onPressedFunction: () {
                              Navigator.pushNamed(context,  '/edit_order_details_screen');
                              })),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _tabState = Provider.of<TabState>(context);
    _navigationState = Provider.of<NavigationState>(context);

    return NetworkIndicator(
        child: PageContainer(
      child: Scaffold(
          body:FutureBuilder<Order>(
              future: _orderDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: <Widget>[
                      _buildBodyItem(snapshot.data),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: GradientAppBar(
                            appBarTitle: snapshot.data.carttFatora,
                           
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
              ) :Container(),),
                      ),
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
    ));
  }
}
