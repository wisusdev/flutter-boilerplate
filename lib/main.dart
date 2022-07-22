import 'package:boilerplate/screens/home.dart';
import 'package:boilerplate/screens/login.dart';
import 'package:boilerplate/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            home: const CheckAuth(),
            theme: ThemeData.dark().copyWith(
                brightness: Brightness.dark,
                colorScheme: const ColorScheme.dark(
                    primary: Colors.blueAccent
                )
            ),
            themeMode: ThemeMode.dark,
            routes: {
                'home' : (context) => const Home(),
                'login' : (context) => const Login(),
                'register' : (context) => const Register(),
            },
        );
    }
}

class CheckAuth extends StatefulWidget{
    const CheckAuth({Key? key}) : super(key: key);

    @override
    CheckAuthState createState() => CheckAuthState();
}

class CheckAuthState extends State<CheckAuth>{
    bool isAuth = false;

    @override
    void initState(){
        super.initState();
        checkIfLoggedIn();
    }

    void checkIfLoggedIn() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var token = localStorage.getString('token');
        if(token != null){
            if(mounted){
                setState(() {
                    isAuth = true;
                });
            }
        }
    }

    @override
    Widget build(BuildContext context){
        Widget child;
        if(isAuth){
            child = const Home();
        } else{
            child = const Login();
        }

        return Scaffold(
            body: child,
        );
    }
}