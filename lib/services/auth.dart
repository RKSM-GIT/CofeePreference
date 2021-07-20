import 'package:coffee_preference/services/database.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:coffee_preference/models/user.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object from firebaseUser
  MyUser? _userFromFirebaseUser(User? x)
  {
    return x != null ? MyUser(uid : x.uid) : null;
  }

  //auth changes user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map( _userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future SignInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e) {
        return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //Create a new document for user using uid
      await DatabaseService(uid: user!.uid).updateUserData("0", "New Member", 100);

      return _userFromFirebaseUser(user);

    } catch(e) {
        return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return _auth.signOut();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
}