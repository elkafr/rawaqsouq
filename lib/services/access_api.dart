import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Services {
// next three lines makes this class a Singleton

  static Services _instance = new Services.internal();
  Services.internal();
  factory Services() => _instance;

  static final _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

      
  Future<Map> post(String url, {body, header}) async {
 
    return http
        .post(
          Uri.encodeFull(url),
          
            body: json.encode(body),
            headers: header == null ? _headers : header
            )
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      dynamic responseDecoded = json.decode(response.body);
      print(statusCode.toString());
      print(responseDecoded);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return {
          'response': '0',
          'message': 'حدث خطأ فى تحميل البيانات',
        };
      } else {
        return responseDecoded;
      }
    });
  }

  Future<Map> get(String url,{Map<String, String> header}) async {
   
    return http.get(Uri.encodeFull(url),
       headers: header == null ? _headers : header
       ).then((http.Response response) {
      final int statusCode = response.statusCode;
      dynamic responseDecoded = json.decode(response.body);
      print(statusCode.toString());
      print(responseDecoded);
       if (statusCode < 200 || statusCode > 400 || json == null) {
        return {
          'response': '0',
          'message': 'حدث خطأ فى تحميل البيانات',
        };
      } else {
        return responseDecoded;
      }
    });
  }
}
