import 'package:firebase_auth/firebase_auth.dart';
import 'package:vengo_del_super/models/user.dart';
import 'package:vengo_del_super/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future registerWithEmailAndPassword(String email, String password, String nombre, String telefono) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          
      FirebaseUser user = result.user;

      // create a document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(nombre, telefono);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
