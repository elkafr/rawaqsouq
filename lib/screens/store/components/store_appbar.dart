import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/store_state.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class StoreAppBar extends StatefulWidget {
  
  @override
  _StoreAppBarState createState() => _StoreAppBarState();
}

class _StoreAppBarState extends State<StoreAppBar> {
  bool _initialRun = true;
  AppState _appState;
  Services _services = Services();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _appState = Provider.of<AppState>(context);
      _initialRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreState>(builder: (context, storeState, child) {
      return Stack(
        children: <Widget>[
          Container(
            height: 100,
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
          ),
          Positioned(
            right: 0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: cWhite,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(storeState.currentStore.mtgerName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1),
                Container(
                    child: _appState.currentUser == null
                        ? IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: cWhite,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login_screen');
                            },
                          )
                        : Consumer<StoreState>(
                            builder: (context, storeState, child) {
                            return IconButton(
                                icon: storeState.isFavouriteList[
                                            storeState.currentStore.mtgerId] ==
                                        1
                                    ? SpinKitPumpingHeart(
                                        color: cPrimaryColor,
                                        size: 24,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: cWhite,
                                      ),
                                onPressed: () async {
                                  // print(
                                  //     ' before :value ${chaletState.isFavourite[widget.chalet.id]}');
                                  storeState.updateChangesOnFavouriteList(
                                      storeState.currentStore.mtgerId);
                                  // print(
                                  //     ' after : value ${chaletState.isFavourite[widget.chalet.id]}');

                                  if (storeState.isFavouriteList[
                                          storeState.currentStore.mtgerId] ==
                                      1) {
                                    await _services.get(
                                        'https://works.rawa8.com/apps/souq//api/delete_save_ads?user_id=${_appState.currentUser.userId}&mtger_id=${storeState.currentStore.mtgerId}');
                                  } else {
                                    await _services.get(
                                        'https://works.rawa8.com/apps/souq//api/add_fav?user_id=${_appState.currentUser.userId}&mtger_id=${storeState.currentStore.mtgerId}');
                                  }
                                });
                            ;
                          }))
              ],
            ),
          ),
        ],
      );
    });
  }
}
