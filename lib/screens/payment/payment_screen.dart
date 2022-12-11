import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawaqsouq/app_repo/app_state.dart';
import 'package:rawaqsouq/app_repo/location_state.dart';
import 'package:rawaqsouq/app_repo/payment_state.dart';
import 'package:rawaqsouq/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/custom_text_form_field/custom_text_form_field.dart';
import 'package:rawaqsouq/components/drop_down_list_selector/default_shape_drop_down.dart';
import 'package:rawaqsouq/components/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:rawaqsouq/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/bank.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:validators/validators.dart';
import 'package:rawaqsouq/app_repo/product_state.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double _height = 0, _width = 0;
  ProgressIndicatorState _progressIndicatorState;
  LocationState _locationState;
  File _imageFile;
  dynamic _pickImageError;
  Bank _selectedBank;
  Services _services = Services();
  Future<List<Bank>> _bankList;
  bool _initialRun = true;
  AppState _appState;
  ProductState _productState;
  PaymentState _paymentState;
final _imagePicker = ImagePicker();
String _bankName = '' , _bankAcount = '', _bankIban = '';


  final _formKey = GlobalKey<FormState>();
  String _accountOwner = '', _accountNo = '', _iban = '' , _imgIsDetected = '';

  Future<List<Bank>> _getBankList() async {
    Map<String, dynamic> results =
        await _services.get('${Utils.BANKS_URL}lang=${_appState.currentLang}');
    List bankList = List<Bank>();
    if (results['response'] == '1') {
      Iterable iterable = results['bank'];
      bankList = iterable.map((model) => Bank.fromJson(model)).toList();
    } else {
      showErrorDialog(results['message'], context);
    }
    return bankList;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _appState = Provider.of<AppState>(context);
      _productState = Provider.of<ProductState>(context);
      _bankList = _getBankList();
      _initialRun = false;
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
       final pickedFile = await  _imagePicker.getImage(
        source: source,
      );
      setState(() {
      _imageFile = File(pickedFile.path);
      if(_imageFile != null){
      _imgIsDetected = AppLocalizations.of(context).detectImg;
      }
    });
   
    } catch (e) {
      _pickImageError = e;
    }
  }

  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _imageFile = response.file;
    } else {
      _pickImageError = response.exception.code;
    }
  }
  
  Widget _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: cBlack, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Text(
            value,
            style: TextStyle(
                color: cBlack, fontSize: 14, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Container(
        height: _height  *1.1,
        width: _width,
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: _width * 0.05, vertical: 5),
                  child: Text(
                    AppLocalizations.of(context).choosePaymentMethods,
                    style: TextStyle(color: cHintColor, fontSize: 15),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        bottom: _height * 0.01,
                        left: _width * 0.04,
                        right: _width * 0.04),
                    child: Row(children: <Widget>[
                      Consumer<PaymentState>(
                          builder: (context, paymentState, child) {
                        return GestureDetector(
                          onTap: () =>
                              paymentState.setEnableCardsAndBankAccounts(true),
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.only(
                                left: _width * 0.02, right: _width * 0.02),
                            child: paymentState.enableCardsAndBankAccounts
                                ? Icon(
                                    Icons.check,
                                    color: cWhite,
                                    size: 17,
                                  )
                                : Container(),
                            decoration: BoxDecoration(
                              color: paymentState.enableCardsAndBankAccounts
                                  ? cPrimaryColor
                                  : cWhite,
                              border: Border.all(
                                color: paymentState.enableCardsAndBankAccounts
                                    ? cPrimaryColor
                                    : cHintColor,
                              ),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        );
                      }),
                      Text(
                        AppLocalizations.of(context).paymentByWireTransfer,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'HelveticaNeueW23forSKY',
                            color: cBlack),
                      ),
                    ])),
                Container(
                  height: 75,
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.05),
                  width: _width,
                  child: FutureBuilder<List<Bank>>(
                    future: _bankList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var banklist = snapshot.data.map((item) {
                          return new DropdownMenuItem<Bank>(
                            child: new Text(item.bankTitle),
                            value: item,
                          );
                        }).toList();
                        return DropDownListSelector(
                          validationFunc: (value) {
                            if (_selectedBank == null) {
                              return AppLocalizations.of(context)
                                  .bankValidation;
                            }
                            return null;
                          },
                          dropDownList: banklist,
                          hint: AppLocalizations.of(context).bankName,
                          onChangeFunc:  (newValue) {
                            setState(() {
                              _selectedBank = newValue;
                              _bankName = _selectedBank.bankName;
                              _bankAcount = _selectedBank.bankAcount;
                              _bankIban = _selectedBank.bankIban;
                            });
                          },
                          value: _selectedBank,
                        );
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: cPrimaryColor,
                      ));
                    },
                  ),
                ),
            Container(
                      margin: EdgeInsets.symmetric(horizontal: _width *0.1),
              child: Text( AppLocalizations.of(context).bankAccountDetails,style: TextStyle(
                color: cBlack,fontSize: 13
              ),) ,
            ),
         Container(
           margin: EdgeInsets.symmetric(horizontal: _width *0.08),
           child:    _buildRow(
                                    '${AppLocalizations.of(context).accountOwner}   :   ',
                                   _bankName
                                    )),
                             
                          Container(
           margin: EdgeInsets.symmetric(horizontal: _width *0.08),
           child:       _buildRow(
                                  '${AppLocalizations.of(context).accountNumber}       :   ',
                                  _bankAcount
                                  ),),
                           Container(
           margin: EdgeInsets.symmetric(horizontal: _width *0.08),
           child:     _buildRow(
                                    '${AppLocalizations.of(context).iban}         :   ',
                                   _bankIban
                                    ),),
                            
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: _width,
                  child: CustomTextFormField(
                      hintTxt: AppLocalizations.of(context).nameOfTransferAccountHolder,
                      inputData: TextInputType.text,
                      onChangedFunc: (String text) {
                        _accountOwner = text;
                      },
                      validationFunc: (value) {
                        if (value.trim().length == 0) {
                          return AppLocalizations.of(context)
                              .nameOfTransferAccountHolder;
                        }
                        return null;
                      }),
                ),
                Container(
                  width: _width,
                  margin: EdgeInsets.only(top: 20),
                  child: CustomTextFormField(
                      hintTxt: AppLocalizations.of(context).accountNumberOfTransferHolder,
                      inputData: TextInputType.number,
                      onChangedFunc: (String text) {
                        _accountNo = text;
                      },
                      validationFunc: (value) {
                        if (value.trim().length == 0 || !isNumeric(value)) {
                          return AppLocalizations.of(context)
                              .accountNumberOfTransferHolder;
                        } 
                        return null;
                      }),
                ),
                // Container(
                //   width: _width,
                //   margin: EdgeInsets.only(top: 20),
                //   child: CustomTextFormField(
                //       hintTxt: AppLocalizations.of(context).iban,
                //       inputData: TextInputType.number,
                //       onChangedFunc: (String text) {
                //         _iban = text;
                //       },
                //       validationFunc: (value) {
                //         if (_iban.trim().length == 0) {
                //           return AppLocalizations.of(context).ibanValidation;
                //         }
                //         else if()
                //         return null;
                //       }),
                // ),
                Container(
                    height: 20,
                    margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: _width * 0.07,
                        left: _width * 0.07),
                    child: Text(
                      AppLocalizations.of(context).hawalaImageValidation,
                      style: TextStyle(
                          fontSize: 15,
                          color: cHintColor,
                          fontWeight: FontWeight.w400),
                    )),
                Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(
                        right: _width * 0.07, left: _width * 0.07),
                    height: 40,
                 
                    child: Row(
                      children: <Widget>[
                        FloatingActionButton(
                            shape:
                                CircleBorder(side: BorderSide(color: cHintColor)),
                            backgroundColor: cWhite,
                            elevation: 0,
                            onPressed: () {
                              _onImageButtonPressed(ImageSource.gallery,
                                  context: context);
                            },
                            heroTag: 'image0',
                            tooltip: 'Pick Image from gallery',
                            child: Platform.isAndroid
                                ? FutureBuilder<void>(
                                    future: _retrieveLostData(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<void> snapshot) {
                                      return const Icon(
                                        Icons.photo_library,
                                        color: Color(0xffEC4117),
                                      );
                                    })
                                : const Icon(
                                    Icons.photo_library,
                                    color: Color(0xffEC4117),
                                  )),
                   Text(_imgIsDetected ,style: TextStyle(
                     color: cBlack, fontSize: 14
                   ),)
                
                      ],
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.05),
                  child: Divider(
                    height: 30,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        bottom: _height * 0.01,
                        left: _width * 0.04,
                        right: _width * 0.04),
                    child: Row(
                      children: <Widget>[
                        Consumer<PaymentState>(
                            builder: (context, paymentState, child) {
                          return GestureDetector(
                            onTap: () => paymentState
                                .setEnableCardsAndBankAccounts(false),
                            child: Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(
                                  left: _width * 0.02, right: _width * 0.02),
                              child: !paymentState.enableCardsAndBankAccounts
                                  ? Icon(
                                      Icons.check,
                                      color: cWhite,
                                      size: 17,
                                    )
                                  : Container(),
                              decoration: BoxDecoration(
                                color: !paymentState.enableCardsAndBankAccounts
                                    ? cPrimaryColor
                                    : cWhite,
                                border: Border.all(
                                  color:
                                      !paymentState.enableCardsAndBankAccounts
                                          ? cPrimaryColor
                                          : cHintColor,
                                ),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          );
                        }),
                        Text(
                          AppLocalizations.of(context).paymentWhenReceiving,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'HelveticaNeueW23forSKY',
                              color: cBlack),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(
                      left: _width * 0.05, right: _width * 0.05),
                  child: Text(
                    AppLocalizations.of(context)
                        .notAvailableDueToPrecautionaryMeasures,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueW23forSKY',
                        color: cBlack),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: 20,
                        left: _width * 0.07,
                        right: _width * 0.07,
                        bottom: 10),
                    child: CustomButton(
                        btnLbl: AppLocalizations.of(context).orderConfirmation,
                        onPressedFunction: () async {
                          if (!_paymentState.enableCardsAndBankAccounts) {
                            _progressIndicatorState.setIsLoading(true);
                            var results = await _services.get(
                              '${Utils.MAKE_ORDER_URL}user_id=${_appState.currentUser.userId}&cartt_phone=${_paymentState.userPhone}&cartt_adress=${_locationState.address}&cartt_mapx=${_locationState.locationLatitude}&cartt_mapy=${_locationState.locationlongitude}&lang=${_appState.currentLang}',
                            );
                            _progressIndicatorState.setIsLoading(false);
                            if (results['response'] == '1') {
                              _productState.zeroCart();
                              showToast(results['message'], context);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context,  '/navigation');
                            } else {
                              showErrorDialog(results['message'], context);
                            
                            }
                          } else {
                            if (_formKey.currentState.validate()) {
                              if (_imageFile == null) {

                                showToast(
                                    AppLocalizations.of(context)
                                        .hawalaImageValidation,
                                    context);
                              } else {
                                  String fileName = Path.basename(_imageFile.path);
                                _progressIndicatorState.setIsLoading(true);
                          FormData formData = new FormData.fromMap({

                            "user_id": _appState.currentUser.userId,
                            "cartt_phone": _paymentState.userPhone,
                            "cartt_adress": _locationState.address,
                            "cartt_mapx": _locationState.locationLatitude,
                            "cartt_mapy":_locationState.locationlongitude,
                            "cartt_name": _accountOwner,
                            "cartt_bank":_selectedBank.bankId,
                            "cartt_acount":_accountNo,
                            "lang":_appState.currentLang
                          });

                          var results = await _services.postWithDio(
                           Utils.BASE_URL +'convert_go',

                              body: formData);
                    
                          _progressIndicatorState.setIsLoading(false);


                              if (results['response'] == '1') {
                                _productState.zeroCart();
                                      showToast(results['message'], context);
                                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context,  '/navigation');
                                    } else {
                                      showErrorDialog(results['message'], context);
                                    }
                              }
                            }
                          }
                        }))
              ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: cPrimaryColor,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).paymentMethods,
          style: Theme.of(context).textTheme.display1),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
    );
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _paymentState = Provider.of<PaymentState>(context);
    _locationState = Provider.of<LocationState>(context);
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
        ),
      ),
    ));
  }
}
