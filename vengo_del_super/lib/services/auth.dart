import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vengo_del_super/models/user.dart';
import 'package:vengo_del_super/services/database.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _user;
  bool _loggedIn = false;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  bool get isLoggedIn {
    return _loggedIn;
  }

  Future registerWithEmailAndPassword(String email, String password, String nombre, String telefono) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          
      FirebaseUser user = result.user;

      // create a document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(nombre, telefono);
      _loggedIn = true;
      notifyListeners();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      _loggedIn = false;
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      notifyListeners();
      _loggedIn = true;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      _loggedIn = false;
      return null;
    }
  }
}
