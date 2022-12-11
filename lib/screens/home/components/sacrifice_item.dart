import 'package:flutter/material.dart';
import 'package:rawaqsouq/app_repo/product_state.dart';
import 'package:rawaqsouq/app_repo/app_state.dart';

import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/sacrifice.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/utils/utils.dart';
import 'package:rawaqsouq/services/access_api.dart';


import 'package:rawaqsouq/components/response_handling/response_handling.dart';





class SacrificesItem extends StatelessWidget {
  final Sacrifice sacrifice;

  const SacrificesItem({Key key, this.sacrifice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productState = Provider.of<ProductState>(context);
    final appState = Provider.of<AppState>(context);
    final progressIndicatorState = Provider.of<ProgressIndicatorState>(context);


    Services _services = Services();

    return Container(
        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.00),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xff203B8A26),
              blurRadius: 15.0,
            )
          ],
          color: cWhite,
          border: Border.all(color: Color(0xff203B8A26), width: 1.0),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 5,
                right: 5,
                child: Container(
                  child: (sacrifice.adsMtgerHasOffer == '1')
                      ? Text(
                          '${sacrifice.adsMtgerOffer}%',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        )
                      : Text(
                          '',
                          style: TextStyle(
                              fontSize: 0, color: Colors.white, height: 0),
                        ),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: cAccentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.00),
                    ),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    productState.setProductId(sacrifice.adsMtgerId);
                    productState.setProductTitle(sacrifice.adsMtgerName);
                    Navigator.pushNamed(context, '/product_screen');
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 45,
                    backgroundImage: NetworkImage(sacrifice.adsMtgerPhoto),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    productState.setProductId(sacrifice.adsMtgerId);
                    productState.setProductTitle(sacrifice.adsMtgerName);
                    Navigator.pushNamed(context, '/product_screen');
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      sacrifice.adsMtgerName,
                      style: TextStyle(
                          color: cBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.00),
                          ),
                          color: cWhite),
                      child: Text(
                        '${sacrifice.adsMtgerPrice} ${AppLocalizations.of(context).sr}',
                        style: TextStyle(
                          color: cBlack,
                          fontSize: 15,
                          fontFamily: 'HelveticaNeueW23forSKY',
                        ),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                            onTap: () async {
                              if (appState.currentUser != null) {
                                progressIndicatorState.setIsLoading(true);
                                var results = await _services.get(
                                  '${Utils.ADD_TO_CART_URL}${appState.currentLang}&user_id=${appState.currentUser.userId}&ads_id=${sacrifice.adsMtgerId}&amountt=1&cart_price=${sacrifice.adsMtgerPrice}',
                                );
                                progressIndicatorState.setIsLoading(false);
                                if (results['response'] == '1') {
                                  showToast(results['message'], context);
                                  productState.increaseTotalCart();
                                } else {
                                  showErrorDialog(results['message'], context);
                                }
                              } else {
                                Navigator.pushNamed(context, '/login_screen');
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.00),
                                    ),
                                    color: cPrimaryColor),
                                height: 35,

                                child: Text(
                                  '${AppLocalizations.of(context).addToCart}',
                                  style: TextStyle(
                                    color: cWhite,
                                    fontSize: 15,
                                    fontFamily: 'HelveticaNeueW23forSKY',
                                  ),
                                  textAlign: TextAlign.center,
                                ))))
                  ],
                )
              ],
            )
          ],
        ));
  }
}
