import 'package:flutter/material.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Color btnColor;
  final String btnLbl;
  final Function onPressedFunction;
  final TextStyle btnStyle;
  final Widget prefixIcon;
  final Widget postfixIcon;
  final bool hasGradientColor;

  const CustomButton(
      {Key key,
      this.btnLbl,
      this.onPressedFunction,
      this.btnColor,
      this.btnStyle,
      this.prefixIcon,
      this.hasGradientColor = true,
      this.postfixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          height: constraints.maxHeight,
          margin: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.05,
              vertical: constraints.maxHeight * 0.1),
          child: GestureDetector(
            onTap: () {
              onPressedFunction();
            },
            child: Container(
                decoration: hasGradientColor
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        gradient: LinearGradient(
                          colors: [Color(0xff1532C2), Color(0xff0083D3)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]
                          )
                    : BoxDecoration(
                        border: Border.all(width: 1.0, color: cPrimaryColor),
                        borderRadius: BorderRadius.circular(25.0)),
                alignment: Alignment.center,
                child: prefixIcon != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          prefixIcon,
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                '$btnLbl',
                                style: btnStyle == null
                                    ? Theme.of(context).textTheme.button
                                    : btnStyle,
                              ))
                        ],
                      )
                    : postfixIcon != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    '$btnLbl',
                                    style: btnStyle == null
                                        ? Theme.of(context).textTheme.button
                                        : btnStyle,
                                  )),
                              postfixIcon
                            ],
                          )
                        : Text(
                            '$btnLbl',
                            style: btnStyle == null
                                ? Theme.of(context).textTheme.button
                                : btnStyle,
                          )),
          ));
    });
  }
}
