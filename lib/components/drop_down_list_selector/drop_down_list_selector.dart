import 'package:flutter/material.dart';
import 'package:rawaqsouq/utils/app_colors.dart';



class DropDownListSelector extends StatefulWidget {
  final List<dynamic> dropDownList;
  final String hint;
  final dynamic value;
  final Function onChangeFunc;
  final bool elementHasDefaultMargin;
   final Function validationFunc;
   final bool availableErrorMsg;

  const DropDownListSelector(
      {Key key,
      this.dropDownList,
      this.hint,
      this.value,
      this.onChangeFunc,
      this.validationFunc,
      this.availableErrorMsg :true,
      this.elementHasDefaultMargin: true})
      : super(key: key);
  @override
  _DropDownListSelectorState createState() => _DropDownListSelectorState();
}

class _DropDownListSelectorState extends State<DropDownListSelector> {
  @override
  Widget build(BuildContext context) {
    return  FormField<String>(
      validator: widget.validationFunc,
   
      builder: (
          FormFieldState<String> state,
      ) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Container(
        height: 50,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03),
        margin: widget.elementHasDefaultMargin
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08)
            : EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color:   cHintColor.withOpacity(0.20),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: cHintColor),
        ),
        child: 
              DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            isExpanded: true,
            hint: Text(
              widget.hint,
              style: TextStyle(
                  color: cPrimaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'HelveticaNeueW23forSKY'),
            ),
            focusColor: cPrimaryColor,
            icon: Icon(Icons.arrow_drop_down,
              
              color: cHintColor,
            ),
            style: TextStyle(
                fontSize: 14,
                color: cBlack,
                fontWeight: FontWeight.w400,
                fontFamily: 'HelveticaNeueW23forSKY'),
            items: widget.dropDownList,
            onChanged: widget.onChangeFunc,
            value: widget.value,
          ),
    )),
       SizedBox(height: 5.0),
           widget.availableErrorMsg ? Container(
              height: 15,
              margin:  widget.elementHasDefaultMargin
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08)
            : EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                state.hasError ? state.errorText : '',
                style:
                    TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
              ),
            ) :
            Container()
          ]);

    });
  }
}
