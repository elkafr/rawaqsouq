import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/tab_state.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/not_registered/not_registered.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/screens/orders/components/canceled_orders.dart';
import 'package:rawaqsouq/screens/orders/components/done_orders.dart';
import 'package:rawaqsouq/screens/orders/components/processing_orders.dart';
import 'package:rawaqsouq/screens/orders/components/waiting_orders.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
 double _height,_width;


 Widget _buildBodyItem() {
    return  Consumer<AppState>(builder: (context, appState, child) {
       return  appState.currentUser != null
            ?  ListView(
      children: <Widget>[
        Container(
          height: _height - 40,
          child: TabBarView(
            children: [
              WaitingOrders(),
              ProcessingOrders(),
              DoneOrders(),
              CanceledOrders()
            ],
          ),
        )
      ],
    ) :  NotRegistered();
    });
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    TabState tabState = Provider.of<TabState>(context);
  
    return  NetworkIndicator( child:PageContainer(
        child: DefaultTabController(
          initialIndex: tabState.initialIndex,
            length: 4,
            child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),
             Positioned(
               top: 50,
               child:   Container(
                 width: _width,
                      height: 40,
                      color: cWhite,
                      child: TabBar(
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            fontFamily: 'segoeui'),
                        unselectedLabelColor: cBlack,
                        unselectedLabelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'segoeui'),
                        labelColor: cLightLemon,
                        indicatorColor: cLightLemon,
                        tabs: [
                          Text(
                            AppLocalizations.of(context).waiting
                          ),
                          Text(AppLocalizations.of(context).processing),
                          Text(AppLocalizations.of(context).done),
                          Text(AppLocalizations.of(context).canceled)
                        ],
                      )),
             )
             
            ,  Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GradientAppBar(
                  appBarTitle: AppLocalizations.of(context).orders,
                  
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
            
        
            ],
          ))),
    ));
  }
}
