import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network{
    // 10.0.2.2 es el equivalente a 127.0.0.1 en el emulador android
    final url = 'http://10.0.2.2:8000/api';

    var token;


    getToken() async{
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        token = jsonDecode(localStorage.getString('token')!);
    }

    auth(data, apiURL) async {
        var fullUrl = Uri.parse(url + apiURL);
        return await http.post( fullUrl, body: data, headers: setHeaders());
    }

    getData(apiURL) async{
        var fullUrl = Uri.parse(url + apiURL);
        
        await getToken();
        return await http.get(fullUrl, headers: setHeaders()).then((value) => {
            print(value.body)
        });
    }

    postData(apiURL) async{
        var fullUrl = Uri.parse(url + apiURL);
        await getToken();
        return await http.post(fullUrl, headers: setHeaders());
    }

    setHeaders() => {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
    };
}