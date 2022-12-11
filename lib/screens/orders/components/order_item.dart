import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rawaqsouq/app_repo/app_state.dart';
import 'package:rawaqsouq/app_repo/order_state.dart';
import 'package:rawaqsouq/app_repo/progress_indicator_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/components/dialogs/log_out_dialog.dart';
import 'package:rawaqsouq/components/dialogs/rate_dialog.dart';
import 'package:rawaqsouq/components/response_handling/response_handling.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/order.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';
import 'package:rawaqsouq/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'cancel_order_bottom_sheet.dart';
class OrderItem extends StatefulWidget {
  final Order order;
  final bool currentOrder;

  const OrderItem({Key key, this.order, this.currentOrder : true}) : super(key: key);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  Services _services = Services();


   Widget _buildCartItem(String title, int count,int price) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: cBlack,
            fontSize: 14,
            fontFamily: 'HelveticaNeueW23forSKY'),
        children: <TextSpan>[
          TextSpan(text: title),
          TextSpan(text: ' : '),
          TextSpan(
            text: '( $count )',
            style: TextStyle(
                height: 1.3,
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'HelveticaNeueW23forSKY'),
                
          ),
          TextSpan(text:  '  '),
           TextSpan(text:  price.toString()),
                  TextSpan(text:  '  '),
            TextSpan(text:  AppLocalizations.of(context).sr),
        ],
      ),
    );
  }

   Widget _buildItem(String title, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: cBlack,
            fontSize: 14,
            fontFamily: 'HelveticaNeueW23forSKY'),
        children: <TextSpan>[
          TextSpan(text: title),
          TextSpan(text: ' : '),
          TextSpan(
            text: value,
            style: TextStyle(
                height: 1.3,
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'HelveticaNeueW23forSKY'),
                
          ),
      
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
     
    final width = MediaQuery.of(context).size.width;
    final orderState =  Provider.of<OrderState>(context);
    final progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    final appState = Provider.of<AppState>(context);
    return Container(
      width: width,
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.all(10),
      height: 190,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Container(
             margin: EdgeInsets.symmetric(horizontal: 5),
             child: Text(
                 widget.order.carttFatora,
                  style: TextStyle(
                      color: cBlack, fontSize: 16, fontWeight: FontWeight.w700),
                ),
           ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 1,
                width: width ,
                color: Colors.grey[100],
              ),
             Expanded(
               child:   ListView.builder(
                 physics: ClampingScrollPhysics(),
                 itemCount: widget.order.carttDetails.length,
                 itemBuilder: (context,index){
                   return   _buildCartItem(widget.order.carttDetails[index].carttName, widget.order.carttDetails[index].carttAmount,widget.order.carttDetails[index].carttPrice);
                 } ),
             ),
            
               Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 1,
                width: width ,
                color: Colors.grey[100],
              ),
              
              _buildItem(AppLocalizations.of(context).orderDate,widget.order.carttDate),
                 _buildItem(AppLocalizations.of(context).orderPrice,widget.order.carttTotlal.toString()),
       Padding(padding: EdgeInsets.all(5)),
       Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Container(
                    width:   width * 0.35,
                    height: 40,
                    child: CustomButton(
                      buttonOnDialog: true,
                        btnStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: cWhite),
                        btnLbl:AppLocalizations.of(context).orderDetails,
                        onPressedFunction: () {
                       orderState.setCarttFatora(widget.order.carttFatora);
                       Navigator.pushNamed(context,  '/order_details_screen'); 
                        }),
                  ),
             widget.currentOrder ?       Container(
                    width: width *0.35,
                    height: 40,
                    child: CustomButton(
                      buttonOnDialog: true,
                         btnStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: cBlack),
                    
                      btnLbl: AppLocalizations.of(context).cancelOrder,
                      btnColor: cAccentColor,
                      borderColor: cAccentColor,
                      onPressedFunction: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (builder) {
                              return Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: CancelOrderBottomSheet(
                                  onPressedConfirmation: () async {
                                   progressIndicatorState.setIsLoading(true);
                                    var results = await _services.get(
                               '${Utils.CANCEL_ORDER_URL}cartt_fatora=${widget.order.carttFatora}&lang=${appState.currentLang}');
                                    progressIndicatorState.setIsLoading(false);
                                    if (results['response'] == '1') {
                                      showToast(results['message'], context);
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                          context, '/navigation');
                                    } else {
                                      showErrorDialog(
                                          results['message'], context);
                                    }
                                  },
                                ),
                              );
                            });
                     //  showDialog(
                        // barrierDismissible: true,
                        // context: context,
                        // builder: (_) {
                        //   return LogoutDialog(
                        //     alertMessage:
                        //         AppLocalizations.of(context).wantToCancelOrder,
                        //     onPressedConfirm: () async {
                        //      progressIndicatorState.setIsLoading(true);
                        //             var results = await _services.get(
                        //        '${Utils.CANCEL_ORDER_URL}cartt_fatora=${widget.order.carttFatora}&lang=${appState.currentLang}');
                        //             progressIndicatorState.setIsLoading(false);
                        //             if (results['response'] == '1') {
                        //               showToast(results['message'], context);
                        //               Navigator.pop(context);
                        //               Navigator.pushReplacementNamed(
                        //                   context, '/navigation');
                        //             } else {
                        //               showErrorDialog(
                        //                   results['message'], context);
                        //             }
                        //     },
                        //   );
                        // });
                      

                      },
                    ),
                  ) :  widget.order.rate  == 0 ? Container(
                    width: width *0.35,
                    height: 40,
                    child: CustomButton(
                      buttonOnDialog: true,
                         btnStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: cBlack),
                    
                      btnLbl: AppLocalizations.of(context).addRate ,
                      btnColor: cAccentColor,
                      borderColor: cAccentColor,
                      onPressedFunction: () {
                         showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return RateDialog(
                            cartFatora: widget.order.carttFatora,
                          );
                        });
                      })) :
                     Row(
                       children: <Widget>[
                         SmoothStarRating(
          allowHalfRating: true,
        
          starCount: 5,
          rating: double.parse(widget.order.rate.toString()),
          size: 25.0,
           color: Color(0xffFFCE42),
          borderColor: Color(0xffA5A1A1),
          spacing:0.0
        ),
         Text('( ${widget.order.rate} )',style: TextStyle(
                                             color: Color(0xffA5A1A1),fontSize: 12
                                           ),)
                       ],
                     ),
                      
                ],
              ) 
        ],
      ));
  }
}