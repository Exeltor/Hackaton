import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/services/auth.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Introduce un email correcto';
    else
      return null;
  }

  void _showDialog(String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => {_email = val},
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Email is Required';
                        }

                        return validateEmail(value);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Contraseña'),
                      onChanged: (val) => {setState(() => _password = val)},
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Introduce una contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener 6 caracteres mínimo';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        print(_email);
                        print(_password);
                        dynamic result =
                            await Provider.of<AuthService>(context, listen:false).signInWithEmailAndPassword(_email, _password);
                        if (result == null) {
                          setState(() => _showDialog('ERROR',
                              'No se ha podido iniciar sesión con esos credenciales'));
                        }
                      },
                      child: Text('Inicia Sesión'),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            color: Theme.of(context).accentColor,
            child: InkWell(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => RegisterScreen()))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¿Aún no tienes cuenta? Regístrate',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
