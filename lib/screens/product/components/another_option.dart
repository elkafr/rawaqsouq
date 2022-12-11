import 'package:flutter/material.dart';
import 'package:rawaqsouq/utils/app_colors.dart';

class AnotherOption extends StatelessWidget {
final String imgPath;
final String title;
final String value;

  const AnotherOption({Key key, this.imgPath, this.title, this.value}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.02,
      right: MediaQuery.of(context).size.width *0.02,
      bottom: 10
      ),
         decoration: BoxDecoration(
           color: Color(0xffCDC42C).withOpacity(0.10),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.00),
                                ),
                                border: Border.all(color:Color(0xff015B2A).withOpacity(0.10) )),
       child: Row(
         children: <Widget>[
           Image.asset(imgPath),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10)
            ,
            child:  Text( title,style: TextStyle(
             color: cBlack,fontSize: 14,
             fontWeight: FontWeight.w700
           ),),
          ),
          Spacer(),

          Text(value,
          style: TextStyle(
            color: cBlack,fontSize: 11,
            fontWeight: FontWeight.w400
          ),),

          Icon(Icons.arrow_forward_ios ,size: 15,color: cAccentColor,)
          
         ],
       ),                         
    );
  }
}