import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:vengo_del_super/models/userData.dart';

class DatabaseService extends ChangeNotifier{
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference _users = Firestore.instance.collection('users');
  final CollectionReference _listasCompra =
      Firestore.instance.collection('listasDeCompra');

  Future updateUserData(String nombre, String telefono) async {
    return await _users
        .document(uid)
        .setData({'nombre': nombre, 'telefono': telefono});
  }

  Stream<QuerySnapshot> get users {
    return _users.snapshots();
  }

  Stream<QuerySnapshot> get listasCompra {
    return _listasCompra.snapshots();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: snapshot.data['uid'],
      nombre: snapshot.data['nombre'],
      direccion: snapshot.data['direccion'],
      telefono: snapshot.data['telefono'],
      ubicaciones: snapshot.data['ubicaciones'],
    );
  }

  Stream<UserData> user (String userUid) {
    return _users.document(userUid).snapshots().map(_userDataFromSnapshot);
  }

  Future<UserData> userMap(String userUid) async{
    return _userDataFromSnapshot(await _users.document(userUid).get());
  }
}
