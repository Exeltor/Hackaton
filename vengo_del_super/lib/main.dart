import 'package:flutter/material.dart';
import 'package:vengo_del_super/screens/home_screen.dart';
import 'package:vengo_del_super/screens/lista_compra_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.purple,
        canvasColor: Colors.grey[200],
        fontFamily: 'Raleway'
      ),
      home: LoginScreen(),
      routes: {
        ListaCompraScreen.routeName: (context) => ListaCompraScreen(),
      },
    );
  }
}