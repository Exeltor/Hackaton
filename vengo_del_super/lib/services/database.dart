import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference _users = Firestore.instance.collection('users');

  Future updateUserData(String nombre, String telefono) async {
    return await _users.document(uid).setData({
      'nombre': nombre,
      'telefono': telefono
    });
  }

}
