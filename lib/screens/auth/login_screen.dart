import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_data/shared_preferences_helper.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/custom_text_form_field/custom_text_form_field.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/horizontal_divider/horizontal_divider.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/user.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/utils/utils.dart';
import 'package:rawaqsouq/screens/auth/password_recovery_bottom_sheet.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _height;
  double _width;
  final _formKey = GlobalKey<FormState>();
  String _userPhone, _userPassword;
  Services _services = Services();
  ProgressIndicatorState _progressIndicatorState;
  AppState _appState;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: _height * 0.1,
            ),
            Container(
              height: _height * 0.25,
              margin: EdgeInsets.symmetric(horizontal: _width * 0.03),
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            HorizontalDivider(),
            Container(
                margin: EdgeInsets.only(
                  top: _height * 0.03,
                ),
                child: CustomTextFormField(
              iconIsImage: true,
              imagePath: 'assets/images/call.png', 
              hintTxt: AppLocalizations.of(context).phoneNo,
              validationFunc: (value) {
               if (value.trim().length == 0) {
                      return AppLocalizations.of(context).phonoNoValidation;
                    }
                return null;
              },
              inputData: TextInputType.text,
              onChangedFunc: (String text) {
                _userPhone = text.toString();
              },
            )),
            Container(
                margin: EdgeInsets.only(
                  top: _height * 0.005,
                ),
                child: CustomTextFormField(
                    isPassword: true,
                    imagePath: 'assets/images/key.png',
                    iconIsImage: true,
                    hintTxt: AppLocalizations.of(context).password,
                    inputData: TextInputType.text,
                    onChangedFunc: (String text) {
                      _userPassword = text.toString();
                    },
                    validationFunc: (value) {
                      // if (value.trim().length < 4) {
                      //   return AppLocalizations.of(context).passwordValidation;
                      // }
                      // return null;
                    })),
            Container(
                margin: EdgeInsets.only(
                    top: _height * 0.01,
                    bottom: _height * 0.01,
                    right: _width * 0.05,
                    left: _width * 0.05),
                height: _height * 0.05,
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          context: context,
                          builder: (builder) {
                            return SingleChildScrollView(
                                child: Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: PasswordRecoveryBottomSheet(),
                            ));
                          });
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: cBlack, fontSize: 14, fontFamily: 'segoeui'),
                        children: <TextSpan>[
                          TextSpan(text: AppLocalizations.of(context).forgetPassword),
                          TextSpan(
                            text: AppLocalizations.of(context).clickHere,
                            style: TextStyle(
                                color: cLightLemon,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                fontFamily: 'segoeui'),
                          ),
                        ],
                      ),
                    ))),
            Container(
              height: 60,
              child: CustomButton(
                btnLbl: AppLocalizations.of(context).login,
                onPressedFunction: () async {
                  if (_formKey.currentState.validate()) {
                    _firebaseMessaging.getToken().then((token) async {
               //       print('mobile token $token');
                      _progressIndicatorState.setIsLoading(true);
                      var results = await _services.get(
                        '${Utils.LOGIN_URL}?user_phone=$_userPhone&user_pass=$_userPassword&token=$token&lang=${_appState.currentLang}',
                      );
                      _progressIndicatorState.setIsLoading(false);
                      if (results['response'] == '1') {
                        _appState.setCurrentUser(
                            User.fromJson(results['user_details']));

                        SharedPreferencesHelper.save(
                            "user", _appState.currentUser);

                        showToast(results['message'], context);
                        Navigator.pushReplacementNamed(context, '/navigation');
                      } else {
                        showErrorDialog(results['message'], context);
                      }
                    });
                  }
                },
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: Center(
                  child: Text(
                 AppLocalizations.of(context).hasAccount,
                    style:
                        TextStyle(color: cBlack, fontWeight: FontWeight.w400),
                  ),
                )),
            Container(
              height: 60,
              child: CustomButton(
                btnStyle: TextStyle(
                    color: cPrimaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0),
                hasGradientColor: false,
                btnLbl: AppLocalizations.of(context).register,
                btnColor: cWhite,
                onPressedFunction: () {
                  Navigator.pushNamed(context, '/register_screen');
                },
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: _width * 0.05, vertical: _height * 0.02),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/navigation');
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back_ios,
                        color: cLightLemon,
                      ),
                      Text(
                     AppLocalizations.of(context).skip,
                        style: TextStyle(
                            fontSize: 15,
                            color: cLightLemon,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
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
    _appState = Provider.of<AppState>(context);
    print('lang : ${_appState.currentLang}');
    return NetworkIndicator(
        child: PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientAppBar(
                appBarTitle: AppLocalizations.of(context).login,
                leading: _appState.currentLang == 'ar'? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: cWhite,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ) : Container(),
                trailing: _appState.currentLang == 'en' ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: cWhite,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ) : Container()),
          ),
          Center(
            child: ProgressIndicatorComponent(),
          )
        ],
      )),
    ));
  }
}
