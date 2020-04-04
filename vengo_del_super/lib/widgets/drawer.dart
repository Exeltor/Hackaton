import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vengo_del_super/services/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Vengo del Super'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Pedidos en curso'),
            onTap: () {
              
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Preferencias'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar sesion'),
            onTap: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ]
      ),
    );
  }
}