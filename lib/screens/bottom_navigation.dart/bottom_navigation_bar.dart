import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_data/shared_preferences_helper.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/navigation_state.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/user.dart';
import 'package:rawaqsouq/utils/app_colors.dart';


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool _initialRun = true;
  AppState _appState;

  NavigationState _navigationState;

  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.read("user");

    if (userData != null) {
      _appState.setCurrentUser(User.fromJson(userData));
      // _getUnreadNotificationNum();
    }
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
  //   }
  //     else if (!results['status'] &&
  //                       results['statusCode'] == 401) {
  //                     handleUnauthenticated(context);
  //                   } else {
  //                        showErrorDialog(results['msg'], context);
  //                   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _initialRun = false;
      _appState = Provider.of<AppState>(context);
      _checkIsLogin();
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    _navigationState = Provider.of<NavigationState>(context);
    return NetworkIndicator(
        child: Scaffold(
      body: _navigationState.selectedContent,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  AppLocalizations.of(context).home,
                  style: TextStyle(fontSize: 14.0),
                )),
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
               AppLocalizations.of(context).orders,
                  style: TextStyle(fontSize: 14.0),
                )),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  AppLocalizations.of(context).favourite,
                  style: TextStyle(fontSize: 14.0),
                )),
          ),
          BottomNavigationBarItem(
           icon:  Icon(Icons.local_grocery_store),
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  AppLocalizations.of(context).cart,
                  style: TextStyle(fontSize: 14.0),
                )),
          ),
            BottomNavigationBarItem(
           icon: Icon(Icons.person) ,
            title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  AppLocalizations.of(context).account,
                  style: TextStyle(fontSize: 14.0),
                )),
          )
        ],
        currentIndex: _navigationState.navigationIndex,
        selectedItemColor: cPrimaryColor,
        unselectedItemColor: Color(0xFFC4C4C4),
        onTap: (int index) {
          _navigationState.upadateNavigationIndex(index);
        },
        elevation: 5,
        backgroundColor: cWhite,
        type: BottomNavigationBarType.fixed,
      ),
    ));
  }
}
