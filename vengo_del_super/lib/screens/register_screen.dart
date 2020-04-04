import 'package:flutter/material.dart';
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
  final AuthService _auth = AuthService();
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
      body: SingleChildScrollView(
        child: Column(
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
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
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
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
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
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
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
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
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
                    ),
                    Container(
                      child: FlatButton(
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
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  _email, _password1, _nombre, _telefono);
                          if (result == null) {
                            _showDialog('ERROR',
                                'No se ha podido registrar el usuario');
                          }
                        },
                        child: Text('Regístrese'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              color: Theme.of(context).accentColor,
              child: InkWell(
                onTap: () => {Navigator.of(context).pop()},
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
      ),
    );
  }
}
