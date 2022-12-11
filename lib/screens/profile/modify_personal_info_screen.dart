import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_data/shared_preferences_helper.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/custom_text_form_field/custom_text_form_field.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:validators/validators.dart';

class ModifyPersonalInformationScreen extends StatefulWidget {
  @override
  _ModifyPersonalInformationScreenState createState() =>
      _ModifyPersonalInformationScreenState();
}

class _ModifyPersonalInformationScreenState
    extends State<ModifyPersonalInformationScreen> {
  var _height, _width;
  final _formKey = GlobalKey<FormState>();
  ProgressIndicatorState _progressIndicatorState;
  Services _services = Services();
  AppState _appState;
  String _userEmail, _userName, _userPhone;

  bool _initialRun = true;

  Widget _buildBodyItem() {
    return Consumer<AppState>(builder: (buildContext, appState, child) {
      return SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: _height * 0.03,
                        left: _width * 0.025,
                        right: _width * 0.025),
                    child: CustomTextFormField(
                      initialValue: appState.currentUser.userName,
                      prefixIcon: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.person,
                          size: 24,
                        ),
                      ),
                      hintTxt: AppLocalizations.of(context).name,
                      validationFunc: (value) {
                        if (value.trim().length == 0) {
                          return AppLocalizations.of(context).nameValidation;
                        }
                        return null;
                      },
                      inputData: TextInputType.text,
                      onChangedFunc: (String text) {
                        _userName = text.toString();
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(
                        left: _width * 0.025, right: _width * 0.025),
                    child: CustomTextFormField(
                      initialValue: appState.currentUser.userPhone,
                      prefixIcon: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.phone_in_talk,
                          size: 24,
                        ),
                      ),
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
                        left: _width * 0.025, right: _width * 0.025),
                    child: CustomTextFormField(
                      initialValue: appState.currentUser.userEmail,
                      prefixIcon: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.mail,
                          size: 24,
                        ),
                      ),
                      hintTxt: AppLocalizations.of(context).email,
                      validationFunc: (value) {
                        if (!isEmail(value)) {
                          return AppLocalizations.of(context).emailValidation;
                        }
                        return null;
                      },
                      inputData: TextInputType.text,
                      onChangedFunc: (String text) {
                        _userEmail = text.toString();
                      },
                    )),
                Spacer(),
                Divider(),
                Container(
                   margin: EdgeInsets.only(
                        left: _width * 0.025, right: _width * 0.025),
                  height: 60,
                  child: CustomButton(
                    btnLbl: AppLocalizations.of(context).save,
                    onPressedFunction: () async {
                      if (_formKey.currentState.validate()) {
                        _progressIndicatorState.setIsLoading(true);

                        var results = await _services.get(
                          'https://works.rawa8.com/apps/souq/api/profile?user_email=$_userEmail&user_name=$_userName&user_phone=$_userPhone&user_id=${_appState.currentUser.userId}&lang=${_appState.currentLang}',
                        );
                        _progressIndicatorState.setIsLoading(false);
                        if (results['response'] == '1') {

                          _appState.updateUserEmail(_userEmail);
                          _appState.updateUserName(_userName);
                          _appState.updateUserPhone(_userPhone);
                              SharedPreferencesHelper.save(
                                  "user", _appState.currentUser);
                                  showToast( results['message'], context);
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(context, '/personal_information_screen');
                        } else {
                          showErrorDialog(results['message'], context);
                        }
                  
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _initialRun = false;
      _appState = Provider.of<AppState>(context);
      _userEmail = _appState.currentUser.userEmail;
      _userName = _appState.currentUser.userName;
      _userPhone = _appState.currentUser.userPhone;
    }
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);

    return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientAppBar(
              appBarTitle: AppLocalizations.of(context).editInfo,
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
              ) :Container(),
            ),
          ),
          Center(
            child: ProgressIndicatorComponent(),
          )
        ],
      )),
    ));
  }
}
