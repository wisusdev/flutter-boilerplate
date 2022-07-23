import 'dart:convert';

import 'package:boilerplate/network/api.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
    const Register({Key? key}) : super(key: key);

    @override
    State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    String? name, username, email, password, passwordConfirmation;

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
                    padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 10, bottom: 60.0),
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
                                                const Text("Registro", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: TextFormField(
                                                        cursorColor: Colors.blue,
                                                        keyboardType: TextInputType.text,
                                                        decoration: const InputDecoration(
                                                            hintText: "Nombre completo",
                                                        ),
                                                        validator: (nameValue){
                                                            if(nameValue == null || nameValue.isEmpty){
                                                                return 'Ingrese su nombre completo';
                                                            }
                                                            name = nameValue;
                                                            return null;
                                                        }
                                                    ),
                                                ),

                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: TextFormField(
                                                        cursorColor: Colors.blue,
                                                        keyboardType: TextInputType.text,
                                                        decoration: const InputDecoration(
                                                            hintText: "Nombre de usuario",
                                                        ),
                                                        validator: (usernameValue){
                                                            if(usernameValue == null || usernameValue.isEmpty){
                                                                return 'Ingrese su nombre de usuario';
                                                            }
                                                            username = usernameValue;
                                                            return null;
                                                        }
                                                    ),
                                                ),

                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: TextFormField(
                                                        cursorColor: Colors.blue,
                                                        keyboardType: TextInputType.emailAddress,
                                                        decoration: const InputDecoration(hintText: "Correo electrónico"),
                                                        validator: (emailValue){                                                   
                                                            if(emailValue == null || emailValue.isEmpty){
                                                                return 'Ingrese su correo electronico';
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
                                                            hintText: "Contraseña",
                                                            suffixIcon: IconButton(
                                                                onPressed: showHide,
                                                                icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                                                            ),
                                                        ),
                                                        validator: (passwordValue){
                                                            if(passwordValue == null || passwordValue.isEmpty){
                                                                return 'Ingrese su contraseña';
                                                            }
                                                            password = passwordValue;
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
                                                            hintText: "Confirmar contraseña",
                                                            suffixIcon: IconButton(
                                                                onPressed: showHide,
                                                                icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility)
                                                            ),
                                                        ),
                                                        validator: (passwordConfirmationValue){
                                                            if(passwordConfirmationValue == null || passwordConfirmationValue.isEmpty){
                                                                return 'Confirme su contraseña';
                                                            }
                                                            passwordConfirmation = passwordConfirmationValue;
                                                            return null;
                                                        }
                                                    ),
                                                ),
                                
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                            if (_formKey.currentState!.validate()) {
                                                                register();
                                                            }
                                                        },
                                                        child: const Text('Enviar'),
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
                                        Navigator.pushNamed(context, 'login');
                                    },
                                    child: const Text(
                                        '¿Ya tienes una cuenta?',
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

    void register() async {

        setState(() {
            _isLoading = true;
        });

        Map<String, dynamic> data = {
            'name' : name,
            'username' : username,
            'email' : email,
            'password' : password,
            'password_confirmation' : passwordConfirmation
        };

        var res = await Network().auth(data, '/register');
        var body = json.decode(res.body);

        if (body['success']) {
            if (!mounted) return;
            Navigator.pushNamed(context, 'login');
            _showMsg(body['message'].toString());

        } else {
            if(body['message']['name'] != null){
                _showMsg(body['message']['name'][0].toString());
            }

            else if(body['message']['username'] != null){
                _showMsg(body['message']['username'][0].toString());
            }

            else if(body['message']['email'] != null){
                _showMsg(body['message']['email'][0].toString());
            } 
            
            else if(body['message']['password'] != null){
                _showMsg(body['message']['password'][0].toString());
            }
        }

        setState(() {
            _isLoading = false;
        });
    }


}