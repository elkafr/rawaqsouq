import 'package:flutter/material.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String initialValue;
  final String hintTxt;
  final TextInputType inputData;
  final bool isPassword;
  final Function validationFunc;
  final Function onChangedFunc;
  final Widget suffixIcon;
  final int maxLength;
  final int maxLines;
  final Widget prefixIcon;
  // this variable to detect icon as image
  final bool iconIsImage;
  final String imagePath;
  CustomTextFormField(
      {this.hintTxt,
      this.inputData,
      this.isPassword: false,
      this.validationFunc,
      this.onChangedFunc,
      this.initialValue,
      this.suffixIcon,
      this.maxLength,
      this.iconIsImage :false,
      this.imagePath,
      this.maxLines =1,
      this.prefixIcon});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obsecureText = true;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();
    super.dispose();
  }

  Widget _buildTextFormField() {
    return TextFormField(
      maxLines: widget.maxLines,
      focusNode: focusNode,
      maxLength: widget.maxLength,
      initialValue: widget.initialValue,
      
      style:
          TextStyle(color: cBlack, fontSize: 15, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23.0),
            borderSide: BorderSide(
                color: focusNode.hasFocus ? cPrimaryColor : cHintColor),
          ),
          focusColor: cPrimaryColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
          suffixIcon: widget.suffixIcon,
          prefixIcon: !widget.iconIsImage
              ? widget.prefixIcon
              : focusNode.hasFocus
                  ? Image.asset(
                      widget.imagePath,
                      color: cPrimaryColor,
                    )
                  : Image.asset(
                      widget.imagePath,
                      color: Colors.grey,
                    ) ,
          hintText: widget.hintTxt,
     
          errorStyle: TextStyle(fontSize: 12.0),
          hintStyle: TextStyle(
              color: focusNode.hasFocus ? cPrimaryColor : cHintColor,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          suffix: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obsecureText = !_obsecureText;
                    });
                  },
                  child: Icon(
                    _obsecureText ? Icons.remove_red_eye : Icons.visibility_off,
                    color: focusNode.hasFocus ? cPrimaryColor : cHintColor,
                    size: 24,
                  ),
                )
              : null),
      keyboardType: widget.inputData,
      obscureText: widget.isPassword ? _obsecureText : false,
      validator: widget.validationFunc,
      onChanged: widget.onChangedFunc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: _buildTextFormField());
  }
}
