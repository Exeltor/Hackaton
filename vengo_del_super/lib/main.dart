import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/providers/compraService.dart';
import 'package:vengo_del_super/screens/confirmar_compra_screen.dart';
import 'package:vengo_del_super/screens/customer_submit_address_screen.dart';
import 'package:vengo_del_super/screens/lista_listas_screen.dart';
import 'package:vengo_del_super/screens/home_screen.dart';
import 'package:vengo_del_super/screens/lista_compra_screen.dart';
import 'package:vengo_del_super/screens/pedidos_activos.dart';
import 'package:vengo_del_super/services/auth.dart';
import 'package:vengo_del_super/services/database.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CompraService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatabaseService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.purple,
              canvasColor: Colors.grey[200],
              fontFamily: 'Raleway'),
          home: auth.isLoggedIn
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (context, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : LoginScreen()),
          routes: {
            HomeScreen.routeName: (context) => HomeScreen(),
            ListaCompraScreen.routeName: (context) => ListaCompraScreen(),
            CustomerSubmitAddressScreen.routeName: (context) =>
                CustomerSubmitAddressScreen(),
            ListadeListasScreen.routeName: (context) => ListadeListasScreen(),
            ConfirmarCompraScreen.routeName: (context) => ConfirmarCompraScreen(),
            PedidosActivosScreen.routeName: (context) => PedidosActivosScreen(),
          },
        ),
      ),
    );
  }
}
