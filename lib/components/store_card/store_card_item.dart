import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/store_state.dart';
import 'package:rawaqsouq/models/store.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class StoreCardItem extends StatefulWidget {
  final Store store;

  const StoreCardItem({Key key, this.store}) : super(key: key);
  @override
  _StoreCardItemState createState() => _StoreCardItemState();
}

class _StoreCardItemState extends State<StoreCardItem> {
  Services _services = Services();

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<AppState>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Image.network(
                  widget.store.adsPhoto,
                  width: constraints.maxWidth * 0.2,
                  height: constraints.maxHeight,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 1,
                height: constraints.maxHeight * 0.7,
                color: Colors.grey,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: constraints.maxHeight * 0.3,
                    child: Text(
                      widget.store.mtgerName,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: constraints.maxHeight * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Tab(
                              icon: Image.asset(
                            'assets/images/supermarket.png',
                            color: cLightLemon,
                          )),
                        ),
                        Text(
                          widget.store.mtgerCat,
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Color(0xffC5C5C5),
                        size: 20,
                      ),
                      Text(
                        widget.store.mtgerAdress,
                        style:
                            TextStyle(fontSize: 13, color: Color(0xffC5C5C5)),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          Positioned(
            left: _appState.currentLang == 'ar' ? 0 : constraints.maxWidth *0.8,
              right: _appState.currentLang != 'ar' ? 0 : constraints.maxWidth *0.8,
              top: 0,
              child: _appState.currentUser == null
                  ? IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: cPrimaryColor,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login_screen');
                      },
                    )
                  : Consumer<StoreState>(builder: (context, storeState, child) {
                      print(
                          'id ${widget.store.mtgerId} value ${storeState.isFavouriteList[widget.store.mtgerId]}');
                      return IconButton(
                          icon: storeState
                                      .isFavouriteList[widget.store.mtgerId] ==
                                  1
                              ? SpinKitPumpingHeart(
                                  color: cPrimaryColor,
                                  size: 24,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: cPrimaryColor,
                                ),
                          onPressed: () async {
                            print(
                                ' before :value ${storeState.isFavouriteList[widget.store.mtgerId]}');
                          
                        
                            print(
                                ' after :value ${storeState.isFavouriteList[widget.store.mtgerId]}');
                      if (storeState
                                    .isFavouriteList[widget.store.mtgerId] ==
                                1) {
                              print('you should delete');
                              await _services.get(
                                  'https://works.rawa8.com/apps/souq/api/delete_save_ads?user_id=${_appState.currentUser.userId}&mtger_id=${widget.store.mtgerId}');
                            } else {
                              print('you should add');
                              await _services.get(
                                  'https://works.rawa8.com/apps/souq/api/add_fav?user_id=${_appState.currentUser.userId}&mtger_id=${widget.store.mtgerId}');
                            }
                                storeState.updateChangesOnFavouriteList(
                                widget.store.mtgerId);
      
                          });
                    }))
        ],
      );
    });
  }
}
