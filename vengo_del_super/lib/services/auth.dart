import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vengo_del_super/models/user.dart';
import 'package:vengo_del_super/services/database.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';
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
      uid = user.uid;
      await DatabaseService().updateUserData(nombre, telefono);
      _loggedIn = true;
      notifyListeners();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      _loggedIn = false;
      return null;
    }
  }

  Future<bool> autoLogin() async {
    final user = await _auth.currentUser();
    if (user == null) return false;
    uid = user.uid;
    _loggedIn = true;
    notifyListeners();
    return true;
  }
  

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      uid = user.uid;
      _loggedIn = true;
      notifyListeners();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      _loggedIn = false;
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      _loggedIn = false;
      uid = '';
      notifyListeners();
    } catch (e) {
      print('bro');
    }
  }
}
