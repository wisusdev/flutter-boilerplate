import 'dart:convert';

import 'package:boilerplate/network/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
    const Login({Key? key}) : super(key: key);

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    String? email, password;

    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    bool _secureText = true;
    bool _isLoading = false;

    showHide(){
        setState(() {
            _secureText = !_secureText;
        });
    }

    _showMsg(msg) {
        final snackBar = SnackBar(
            content: Text(msg),
            action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                    // Some code to undo the change!
                },
            ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color(0xff151515),
            body: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 72),
                    child: Column(
                        children: [
                            Card(
                                elevation: 4.0,
                                color: Colors.white10,
                                margin: const EdgeInsets.only(top: 86),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: TextFormField(
                                                        cursorColor: Colors.blue,
                                                        keyboardType: TextInputType.emailAddress,
                                                        decoration: const InputDecoration(hintText: "Email"),
                                                        validator: (emailValue){                                                   
                                                            if(emailValue == null || emailValue.isEmpty){
                                                                return 'Please enter your email';
                                                            }
                                                            email = emailValue;
                                                            return null;
                                                        }
                                                    ),
                                                ),

                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: TextFormField(
                                                        cursorColor: Colors.blue,
                                                        keyboardType: TextInputType.text,
                                                        obscureText: _secureText,
                                                        decoration: InputDecoration(
                                                            hintText: "Password",
                                                            suffixIcon: IconButton(
                                                                onPressed: showHide,
                                                                icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                                                            ),
                                                        ),
                                                        validator: (passwordValue){
                                                            if(passwordValue == null || passwordValue.isEmpty){
                                                                return 'Please enter your password';
                                                            }
                                                            password = passwordValue;
                                                            return null;
                                                        }
                                                    ),
                                                ),
                                
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                            if (_formKey.currentState!.validate()) {
                                                                login();
                                                            }
                                                        },
                                                        child: const Text('Submit'),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            ),

                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: InkWell(
                                    onTap: () {
                                        Navigator.pushNamed(context, 'register');
                                    },
                                    child: const Text(
                                        'Create new Account',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.normal,
                                        ),
                                     ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    void login() async {
        setState(() {
            _isLoading = true;
        });

        Map<String, dynamic> data = {
            'email' : email,
            'password' : password
        };

        var response = await Network().auth(data, '/login');
        var body = json.decode(response.body);

        print(body);

        if (body['success']) {
            SharedPreferences localStorage = await SharedPreferences.getInstance();
            localStorage.setString('token', json.encode(body['data']['access_token']));
            localStorage.setString('user', json.encode((body['data']['user'])));
            
            if (!mounted) return;
            Navigator.pushNamed(context, 'home');
        } else{
            _showMsg(body['message']);
        }

        setState(() {
            _isLoading = false;
        });
    }


}