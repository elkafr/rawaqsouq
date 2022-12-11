import 'package:flutter/material.dart';
import 'package:rawaqsouq/app_repo/app_state.dart';
import 'package:rawaqsouq/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/custom_text_form_field/custom_text_form_field.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/utils/utils.dart';
import 'package:provider/provider.dart';


class ModifyPasswordScreen extends StatefulWidget {
  @override
  _ModifyPasswordScreenState createState() => _ModifyPasswordScreenState();
}

class _ModifyPasswordScreenState extends State<ModifyPasswordScreen> {
  double _height, _width;
  bool _initialRun = true;
  AppState _appState;
  Services _services = Services();
  String _useroLdPassword = '', _userNewPassword = '', _confirmNewPassword = '';
  ProgressIndicatorState _progressIndicatorState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _appState = Provider.of<AppState>(context);
      _initialRun = false;
    }
  }

  bool _checkValidation(BuildContext context,
      {String oldPassword, String newPassword, String confirmNewPassword}) {
    if (oldPassword.trim().length == 0) {
      showToast(AppLocalizations.of(context).passwordValidation, context,
          color: cRed);
      return false;
    } else if (newPassword.trim().length == 0) {
      showToast(AppLocalizations.of(context).passwordValidation, context,
          color: cRed);
      return false;
    } else if (confirmNewPassword.trim().length == 0) {
      showToast(AppLocalizations.of(context).passwordValidation, context,
          color: cRed);
      return false;
    } else
     if (confirmNewPassword != newPassword) {
      showToast(AppLocalizations.of(context).passwordNotIdentical, context,
          color: cRed);
      return false;
    }
    return true;
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
        child: Container(
            height: _height,
            width: _width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextFormField(
                    prefixIconIsImage: true,
                    prefixIconImagePath: 'assets/images/key.png',
                    isPassword: true,
                    hintTxt: AppLocalizations.of(context).oldPassword,
                    inputData: TextInputType.text,
                    onChangedFunc: (String text) {
                      _useroLdPassword = text.toString();
                    },
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: CustomTextFormField(
                        prefixIconIsImage: true,
                        prefixIconImagePath:  'assets/images/key.png',
                        isPassword: true,
                        hintTxt: AppLocalizations.of(context).newPassword,
                        inputData: TextInputType.text,
                        onChangedFunc: (String text) {
                          _userNewPassword = text.toString();
                        },
                      )),
                  Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: CustomTextFormField(
                        prefixIconIsImage: true,
                        prefixIconImagePath:  'assets/images/key.png',
                        isPassword: true,
                        hintTxt:
                            AppLocalizations.of(context).confirmNewPassword,
                        inputData: TextInputType.text,
                        onChangedFunc: (String text) {
                          _confirmNewPassword = text.toString();
                        },
                      )),
                  Spacer(),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: CustomButton(
                          btnLbl: AppLocalizations.of(context).save,
                          onPressedFunction: () async {
                            if (_checkValidation(context,
                                newPassword: _userNewPassword,
                                oldPassword: _useroLdPassword,
                                confirmNewPassword: _confirmNewPassword)) {
                                   _progressIndicatorState.setIsLoading(true);
                                 var results = await _services.get(
                          '${Utils.UPDATE_PROFILE_URL}user_email=${_appState.currentUser.userEmail}&user_name=${_appState.currentUser.userName}&user_phone=${_appState.currentUser.userPhone}&user_id=${_appState.currentUser.userId}&lang=${_appState.currentLang}&user_pass2=$_useroLdPassword&user_pass=$_userNewPassword&user_pass1=$_userNewPassword',
                        );
                        _progressIndicatorState.setIsLoading(false);
                       
                        if (results['response'] == '1') {
                          showToast(results['message'], context);
                                  showToast( results['message'], context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, '/profile_screen');
                        } else {
                          showErrorDialog(results['message'], context);
                        }
                            }
                          }))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      centerTitle: true,
      title: Text(AppLocalizations.of(context).editPassword,
          style: Theme.of(context).textTheme.display1),
      leading: GestureDetector(
        child: Consumer<AppState>(
            builder: (context,appState,child){
              return appState.currentLang == 'ar' ? Image.asset('assets/images/back_ar.png'):
              Image.asset('assets/images/back_en.png');

            }
          ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return NetworkIndicator(
        child: PageContainer(
            child: Scaffold(
                appBar: appBar,
                body: Stack(
                  children: <Widget>[
                    _buildBodyItem(),
                    Center(
                      child: ProgressIndicatorComponent(),
                    )
                  ],
                ))));
  }
}
