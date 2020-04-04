import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/providers/compraService.dart';
import 'package:vengo_del_super/screens/customer_submit_address_screen.dart';
import 'package:vengo_del_super/screens/home_screen.dart';
import 'package:vengo_del_super/screens/lista_compra_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompraService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.purple,
            canvasColor: Colors.grey[200],
            fontFamily: 'Raleway'),
        home: HomeScreen(),
        routes: {
          ListaCompraScreen.routeName: (context) => ListaCompraScreen(),
          CustomerSubmitAddressScreen.routeName: (context) => CustomerSubmitAddressScreen(),
        },
      ),
    );
  }
}
