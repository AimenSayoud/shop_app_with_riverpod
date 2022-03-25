import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shop_app_second/data/models/user.dart';
import 'package:shop_app_second/data/databases/databsae_user.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initUser(User? user) async {
    if (user == null) return;
    // var tokenVal = await FirebaseMessaging.instance.getToken();
    // DatabaseUserService(user.uid).saveToken(tokenVal);
  }

  AppUser? _userFromFirebaseUser(User? user) {
    initUser(user);
    if (user != null) {
      print('User is signed in!');
      return AppUser(uid: user.uid);
    } else {
      print('User is currently signed out!');
      return null;
    }
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  String errorMessage(String e) {
    if (e == 'weak-password') {
      print('The password provided is too weak.');
      return 'The password provided is too weak.';
    } else if (e == 'email-already-in-use') {
      print('The account already exists for that email.');
      return 'The account already exists for that email.';
    } else if (e == 'user-not-found') {
      print('No user found for that email.');
      return 'No user found for that email.';
    } else if (e == 'invalid-email') {
      print('invalid email.');
      return 'You are using an invalid Email.';
    } else if (e == 'wrong-password') {
      print('Wrong password provided for that user.');
      return 'Wrong password provided for that user.';
    } else if (e == 'network-request-failed') {
      print('check your internet connection.');
      return 'check your internet connection.';
    }
    return 'something went wrong';
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (error) {
      throw errorMessage(error.code);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String username,
      String email,
      String password,
      File userProfilePicture,
      Timestamp dateOfCreation) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user == null) {
        throw Exception("No user found");
      } else {
        await DatabaseUserService(user.uid)
            .saveUser(username, userProfilePicture, dateOfCreation, email);

        return _userFromFirebaseUser(user);
      }
    } on FirebaseAuthException catch (error) {
      throw errorMessage(error.code);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
}
