import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/order_state.dart';
import 'package:rawaqsouq/components/buttons/custom_button.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/models/order.dart';
import 'package:rawaqsouq/screens/order_details/order_details.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class DoneOrder extends StatefulWidget {
  final bool isCancelOrder;
  final Order order;

  const DoneOrder({Key key, this.isCancelOrder = false, this.order})
      : super(key: key);
  @override
  _DoneOrderState createState() => _DoneOrderState();
}

class _DoneOrderState extends State<DoneOrder> {
  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);
        return LayoutBuilder(builder: (context, constraints) {
      return Container(
          margin: EdgeInsets.only(
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.05,
              bottom: constraints.maxHeight * 0.07),
          height: constraints.maxHeight,
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Color(0xffEBEBEB)),
              color: cWhite,
              borderRadius: BorderRadius.circular(
                15.0,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.04,
                    vertical: constraints.maxHeight * 0.04),
                child: Text(
                  widget.order.carttFatora,
                  style: TextStyle(
                      fontSize: 15,
                      color: cPrimaryColor,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.04,
                    // vertical: constraints.maxHeight *0.04
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: cBlack,
                          fontSize: 15,
                          fontFamily: 'segoeui'),
                      children: <TextSpan>[
                        TextSpan(text: '${AppLocalizations.of(context).store}  :  '),
                        TextSpan(
                          text: widget.order.carttMtger,
                          style: TextStyle(
                              color: cPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              fontFamily: 'segoeui'),
                        ),
                      ],
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(
                      left: constraints.maxWidth * 0.04,
                      right: constraints.maxWidth * 0.04,
                      top: constraints.maxHeight * 0.02),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: cBlack,
                          fontSize: 15,
                          fontFamily: 'segoeui'),
                      children: <TextSpan>[
                        TextSpan(text: '${AppLocalizations.of(context).totalPrice}  :  '),
                        TextSpan(
                          text: '${widget.order.carttTotlal} ${AppLocalizations.of(context).sr}',
                          style: TextStyle(
                              color: cPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              fontFamily: 'segoeui'),
                        ),
                      ],
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(
                      left: constraints.maxWidth * 0.04,
                      right: constraints.maxWidth * 0.04,
                      top: constraints.maxHeight * 0.02),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: cBlack,
                          fontSize: 15,
                          fontFamily: 'segoeui'),
                      children: <TextSpan>[
                        TextSpan(text: '${AppLocalizations.of(context).orderDate}  :  '),
                        TextSpan(
                          text: '${widget.order.carttDate}',
                          style: TextStyle(
                              color: cPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              fontFamily: 'segoeui'),
                        ),
                      ],
                    ),
                  )),
              widget.isCancelOrder
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(
                          left: constraints.maxWidth * 0.04,
                          right: constraints.maxWidth * 0.04,
                          top: constraints.maxHeight * 0.02,
                          bottom: constraints.maxHeight * 0.02),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: 15,
                              fontFamily: 'segoeui'),
                          children: <TextSpan>[
                            TextSpan(text: '${AppLocalizations.of(context).orderReceiptTime}   :  '),
                            TextSpan(
                              text:
                                  '${widget.order.carttTawsilDate}  ${widget.order.carttTawsilTime} ',
                              style: TextStyle(
                                  color: cPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  fontFamily: 'segoeui'),
                            ),
                          ],
                        ),
                      )),
              Container(
                  margin: EdgeInsets.only(
                      left: constraints.maxWidth * 0.04,
                      right: constraints.maxWidth * 0.04,
                      top: widget.isCancelOrder
                          ? constraints.maxHeight * 0.02
                          : 0,
                      bottom: constraints.maxHeight * 0.03),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: cBlack,
                          fontSize: 15,
                          fontFamily: 'segoeui'),
                      children: <TextSpan>[
                        TextSpan(text: '${AppLocalizations.of(context).orderStatus}   :  '),
                        TextSpan(
                          text: widget.order.carttState,
                          style: TextStyle(
                              color: cPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              fontFamily: 'segoeui'),
                        ),
                      ],
                    ),
                  )),
              widget.isCancelOrder
                  ? Spacer(
                      flex: 1,
                    )
                  : Container(),
              Container(
                width: constraints.maxWidth * 0.35,
                height: 50,
                child: CustomButton(
                    btnStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: cWhite),
                    btnLbl: AppLocalizations.of(context).orderDetails,
                    onPressedFunction: () {
                      orderState.setCarttFatora(widget.order.carttFatora);
                      orderState.setCarttSeller(widget.order.carttSeller);
                    orderState.setCarttFatora(widget.order.carttFatora);
                      orderState.setCarttSeller(widget.order.carttSeller);
                     
                         orderState.setIsWaitingOrder(false);
                        Navigator.pushNamed(context,  '/order_details_screen'); 
                       
                    }),
              ),
              widget.isCancelOrder
                  ? Spacer(
                      flex: 1,
                    )
                  : Container(),
            ],
          ));
    });
  }
}
