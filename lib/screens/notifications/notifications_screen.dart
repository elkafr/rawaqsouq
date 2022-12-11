import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/no_data/no_data.dart';
import 'package:rawaqsouq/components/not_registered/not_registered.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/notification_item.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/utils/utils.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var _height, _width;
  Services _services = Services();
 Future<List<NotificationItem>> _notificationList;
  AppState _appState;
  bool _initialRun = true;

  Future<List<NotificationItem>> _getNotifications() async {
    Map<String, dynamic> results =
        await _services.get('https://works.rawa8.com/apps/souq/api/my_inbox1?page=1&user_id=${_appState.currentUser.userId}&lang=${_appState.currentLang}');
    List notificationsList = List<NotificationItem>();

    if (results['response'] == '1') {
      Iterable iterable = results['messages'];
      notificationsList = iterable.map((model) => NotificationItem.fromJson(model)).toList();
    } else {
      print('error');
    }
    return notificationsList;
  }

  // Future<Null> _getUnreadNotificationNum() async {
  //   Map<String, dynamic> results =
  //       await _services.get(Utils.NOTIFICATION_UNREAD_URL, header: {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer ${_appState.currentUser.token}'
  //   });

  //   if (results['status']) {
  //     print(results['data']);

  //     _appState.updateNotification(results['data']['count']);
  //   } else if (!results['status'] && results['statusCode'] == 401) {
  //     handleUnauthenticated(context);
  //   } else {
  //     showErrorDialog(results['msg'], context);
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _appState = Provider.of<AppState>(context);
      if (_appState.currentUser != null) {
       _notificationList = _getNotifications();
        // _getUnreadNotificationNum();
      }
      _initialRun = false;
    }
  }

  Widget _buildBodyItem() {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return Consumer<AppState>(builder: (context, appState, child) {
      return _appState.currentUser != null
          ? FutureBuilder<List<NotificationItem>>(
              future: _notificationList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.notifications_active,
                                      color: cLightLemon,
                                    ),
                                    SizedBox(
                                      width: _width * 0.03,
                                    ),
                                    Flexible(
                                      child: RichText(

                                        text: TextSpan(
                                            text: snapshot
                                                .data[index].messageContent,
                                            style: TextStyle(
                                                color: cLightLemon,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(context).fromStore,
                                                  style: TextStyle(
                                                       color: cLightLemon,
                                                fontWeight: FontWeight.w500,
                                                      fontSize: 15)),
                                                      TextSpan(
                                                  text: snapshot.data[index].messageSender,
                                                  style: TextStyle(
                                                       color: cPrimaryColor,
                                                fontWeight: FontWeight.w600,
                                                      fontSize: 15))
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: _width *0.12
                            ),
                            child:  Text(snapshot.data[index].messageDate,
                          style: TextStyle(
                            color: Color(0xffA7A7A7),
                            fontSize: 12,fontWeight: FontWeight.w400
                          ),),
                          ),
                              Divider(
                                color: cHintColor,
                              )
                            ],
                          );
                        });
                  } else {
                    return NoData(
                      message: AppLocalizations.of(context).noNotifications,
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
            )
          :  NotRegistered();
    });
  }

  @override
  Widget build(BuildContext context) {
       _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
      return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
        backgroundColor: cWhite,
          body: Stack(
            children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 50,),
                 Container(
                   height: _height  - 50,
                   width: _width,
                   child:  _buildBodyItem(),
                 )
              ],
            ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GradientAppBar(
                  appBarTitle: AppLocalizations.of(context).notifications,
                
                  trailing: IconButton(
                    icon: Icon(
                      Icons.notifications_active,
                      color: cWhite,
                    ),
                    onPressed: () {
                          
                    },
                  ),
                ),
              ),
            
            ],
          )),
    ));
  }
}
