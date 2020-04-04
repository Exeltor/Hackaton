import 'package:flutter/material.dart';
import 'package:vengo_del_super/screens/hacer_compra.dart';
import 'package:vengo_del_super/styles/font_styles.dart';
import 'package:vengo_del_super/widgets/drawer.dart';

import 'lista_compra_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Center(
              child: Text('logazo aqui'),
            ),
          ),
          Flexible(
            flex: 2,
            child: Card(
              child: InkWell(
                child: Center(
                  child: Text(
                    'Necesito compra',
                    style: homeCardStyle,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(ListaCompraScreen.routeName);
                },
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Card(
              child: InkWell(
                child: Center(
                  child: Text(
                    'Puedo hacer la compra',
                    style: homeCardStyle,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(HacerCompraScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
