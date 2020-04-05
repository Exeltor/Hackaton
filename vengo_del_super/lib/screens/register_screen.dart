import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/screens/login_screen.dart';
import 'package:vengo_del_super/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  String _email;
  String _password1;
  String _password2;
  String _nombre;
  String _telefono;

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
          Flexible(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo.png',
                          height: 120,
                        ),
                        Text(
                          'Vengo del Súper',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Nombre'),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) => {setState(() => _nombre = val)},
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'El nombre no puede estar vacío';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Telefono: +34678546372'),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) => {setState(() => _telefono = val)},
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'El nombre no puede estar vacío';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Correo'),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) => {setState(() => _email = val)},
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Email is Required';
                            }

                            return validateEmail(value);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Contraseña'),
                          onChanged: (val) => {setState(() => _password1 = val)},
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Repite la contraseña'),
                          onChanged: (val) => {setState(() => _password2 = val)},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Introduce una contraseña';
                            }
                            if (value != _password1) {
                              return 'Las contraseñas son diferentes';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            print(_email);
                            print(_password1);
                            print(_nombre);
                            print(_password2);
                            print(_telefono);
                            dynamic result = await Provider.of<AuthService>(
                                    context,
                                    listen: false)
                                .registerWithEmailAndPassword(
                                    _email, _password1, _nombre, _telefono);

                            if (result == null) {
                              _showDialog('ERROR',
                                  'No se ha podido registrar el usuario');
                            } else {
                              Navigator.of(context).pushReplacementNamed('/');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Regístrate',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            color: Theme.of(context).accentColor,
            child: InkWell(
              onTap: () => {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
