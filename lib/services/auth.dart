import 'package:coffee_shop/models/user.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:quizmaker/models/user.dart' as u;


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj base on firebaseUser

  UserMan? _userFromFirebaseUser(User? user){
    return user != null ? UserMan(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserMan?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    // map((User? user) => _userFromFirebaseUser(user!));



  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
        print(e.toString());
        return null;
        }
  }
  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData('0', 'new member', 100);
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;

    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}