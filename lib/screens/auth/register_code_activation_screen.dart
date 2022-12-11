import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class RegisterCodeActivationScreen extends StatefulWidget {
  @override
  _RegisterCodeActivationScreenState createState() =>
      _RegisterCodeActivationScreenState();
}

class _RegisterCodeActivationScreenState
    extends State<RegisterCodeActivationScreen> with TickerProviderStateMixin {
  String _activationCode = '';
  double _height, _width;
  Services _services = Services();
  AppState _appState;
  ProgressIndicatorState _progressIndicatorState;

  Widget _buildPinView() {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          length: 4,
          obsecureText: false,
          inactiveColor: Theme.of(context).primaryColor,
          selectedColor: Theme.of(context).primaryColor,
          animationType: AnimationType.fade,
          animationDuration: Duration(milliseconds: 300),
          borderRadius: BorderRadius.circular(5),
          activeColor: Theme.of(context).primaryColor,
          fieldWidth: 50,
          onCompleted: (v) {
            print("Completed");
          },
          onChanged: (value) {
            _activationCode = value;
            print(value);
          },
        ));
  }

  Widget _buildBodyItem() {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(
                left: _width * 0.2, right: _width * 0.2, top: _height * 0.05),
            child: Center(
                child: Text(
              AppLocalizations.of(context).enterCodeToActivateAccount,
              style: TextStyle(
                color: cBlack,
                fontSize: 17
              ),
              textAlign: TextAlign.center,
            ))),
        SizedBox(
          height: _height * 0.02,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: _width * 0.1,
          ),
          child: _buildPinView(),
        ),
        SizedBox(
          height: _height * 0.08,
        ),
        Container(
            height: 60,
          
            margin: EdgeInsets.symmetric(
              horizontal: _width * 0.1,
            ),
            child: CustomButton(
                btnLbl: AppLocalizations.of(context).activation,
                onPressedFunction: () async {
                  _progressIndicatorState.setIsLoading(true);
                  var results = await _services.get(
                      'https://works.rawa8.com/apps/souq/api/active?user_id=${_appState.currentUser.userId}&user_code=$_activationCode&lang=${_appState.currentLang}');
                  _progressIndicatorState.setIsLoading(false);
                  if (results['response'] == '1') {
                    showToast(results['message'], context);

                    Navigator.pushNamed(context, '/login_screen');
                  } else {
                    showErrorDialog(results['message'], context);
                  }
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);
    final appBar = AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
      return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
        backgroundColor: cWhite,
          body: Stack(
            children: <Widget>[
            ListView(
              children: <Widget>[
                SizedBox(height: 100,),
                 Container(
                   height: _height  - 100,
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
                  appBarTitle: AppLocalizations.of(context).activateCode,
                
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
            
            Center(
            child: ProgressIndicatorComponent(),
          )   ],
          )),
    ));
  
  }
}
