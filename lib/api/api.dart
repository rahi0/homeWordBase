import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CallApi{

//////////// Local Database /////////////////////  
    // final String _url = 'http://10.0.2.2:8000/api/';
    // final String fileCallurl = 'http://10.0.2.2:8000/api/';
    // final String fileShowlurl = 'http://10.0.2.2:8000';


  //////////// Server Database /////////////////////  
    final String _url = 'http://app.homewardbase.com/api/';
    final String fileCallurl = 'http://app.homewardbase.com/api/';
    final String fileShowlurl = 'http://app.homewardbase.com';
   
    postData(data, apiUrl) async {
        var fullUrl = _url + apiUrl;
        //  print(await _setHeaders());
        print("full url is : $fullUrl");
        return await http.post(
            fullUrl, 
            body: jsonEncode(data), 
            headers: await _setHeaders()
        );
        
    }
 

        withoutTokenPostData(data, apiUrl) async {
        var fullUrl = _url + apiUrl;
        //  print(await _setHeaders());
        print("full url is : $fullUrl");
        return await http.post(
            fullUrl, 
            body: jsonEncode(data), 
            headers: await _setwithoutTokenHeaders()
        );
        
    }
    putData(data, apiUrl) async {
        var fullUrl = _url + apiUrl;
        //  print(await _setHeaders());
        print("full url is : $fullUrl");
        return await http.put(
            fullUrl, 
            body: jsonEncode(data), 
            headers: await _setHeaders()
        );
        
    }

   
    getData(apiUrl) async {
       var fullUrl = _url + apiUrl;
       print(fullUrl);
       return await http.get(
         fullUrl, 
         headers:  await _setHeaders()
       );
    }
  
   

       withoutTokengetData(apiUrl) async {
       var fullUrl = _url + apiUrl;
       print(fullUrl);
       return await http.get(
         fullUrl, 
         headers:  await _setwithoutTokenHeaders()
       );
    }


    _setHeaders() async => {
       "Authorization" : 'Bearer ' + await _getToken(),
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
    };

    
    _setwithoutTokenHeaders() async => {
      
        'Content-type' : 'application/json',
        'Accept' : 'application/json',
    };

    

    _getToken() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        print(localStorage.getString('token'));
        return localStorage.getString('token');
       
    }
    getUrl(){
      return _url;
    }

}