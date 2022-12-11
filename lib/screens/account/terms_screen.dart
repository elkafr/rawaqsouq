import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rawaqsouq/components/app_repo/app_state.dart';
import 'package:rawaqsouq/components/connectivity/network_indicator.dart';
import 'package:rawaqsouq/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:rawaqsouq/components/safe_area/page_container.dart';
import 'package:rawaqsouq/locale/localization.dart';
import 'package:rawaqsouq/services/access_api.dart';
import 'package:rawaqsouq/utils/app_colors.dart';


class TermsScreen extends StatefulWidget {
  @override
  TermsScreenState createState() => TermsScreenState();
}

class TermsScreenState extends State<TermsScreen> {

  double _height ,_width;
  AppState _appState;
Services _services = Services();
  bool _initialRun = true;
  Future<String> _termsContent;

  Future<String> _getTermsContent() async {
    var results = await _services.get('https://works.rawa8.com/apps/souq/api/use_policy?lang=${_appState.currentLang}');
    String termsContent = '';
   if (results['response'] == '1') {
      termsContent = results['content'];
    } else {
      print('error');
    }
    return termsContent;
  }



@override
void didChangeDependencies() {
  super.didChangeDependencies();
   if(_initialRun){
       _appState = Provider.of<AppState>(context);
   _termsContent = _getTermsContent();
  _initialRun = false;
   }
}
  


  Widget _buildBodyItem(){
  
  return  Padding(
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder<String>(
          future: _termsContent,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                    SizedBox(
              height: _height * 0.1,
            ),
            Container(
              height: _height * 0.25,
              margin: EdgeInsets.symmetric(horizontal: _width * 0.03),
              child: Center(child: Image.asset('assets/images/warning.png') )
              ),
          
            Divider(),
                  Container(
             
                      padding: EdgeInsets.symmetric(horizontal: _width * 0.05),
                      child: Html(
                        data: snapshot.data,
                      )),
                  SizedBox(
                    height: _height * 0.35,
                  ),
               
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

             return Center(child: SpinKitThreeBounce(color: cPrimaryColor ,size: 40,));
          },
        ));
  }
 
  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;

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
              appBarTitle: AppLocalizations.of(context).terms,
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
    
        ],
      )),
    ));
  }
}
