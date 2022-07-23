import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:boilerplate/network/api.dart';
import 'package:boilerplate/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

    @override
    HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
    String name='';

    @override
    void initState(){
        super.initState();
        _loadUserData();
    }

    _loadUserData() async{
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var user = jsonDecode(localStorage.getString('user')!);

        if(user != null) {
            setState(() {
                name = user['name'];
            });
        }
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            backgroundColor: const Color(0xff151515),
            appBar: AppBar(
                title: const Text('Inicio'),
                backgroundColor: const Color(0xff151515),
                automaticallyImplyLeading: false,
                actions: [
                    IconButton(
                        icon: const Icon(Icons.power_settings_new),
                        onPressed: (){
                            logout();
                        },
                    )
                ],
            ),
            body: SafeArea(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        children: [
                            Row(
                                children: [
                                    const Text('Bienvenido, ', style: TextStyle( fontSize: 20)),
                                    Text(name, style: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold)),
                                ],
                            )
                        ],
                    ),
                ),
            ),
        );
    }

    void logout() async{
        var response = await Network().postData('/logout');

        var body = json.decode(response.body);

        if(body['message'] == "success"){
            SharedPreferences localStorage = await SharedPreferences.getInstance();
            localStorage.remove('user');
            localStorage.remove('token');
            
            if (!mounted) return;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
        }
    }
}