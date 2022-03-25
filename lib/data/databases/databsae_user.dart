import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_app_second/data/models/user.dart';

class DatabaseUserService {
  final String uid;

  DatabaseUserService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(String username, File userProfilePicture,
      Timestamp dateOfCreation, String email) async {
    //save picture
    String? urlOfPic;
    await saveProfileImage(userProfilePicture, username)
        .then((url) => urlOfPic = url);
    // save user
    return await userCollection.doc(uid).set({
      'username': username,
      'userProfilePicture': urlOfPic,
      'dateOfCreation': dateOfCreation,
      'email': email,
    });
  }

  // Future<void> saveToken(String? token) async {
  //   return await userCollection.doc(uid).update({'token': token});
  // }

  Future<String> saveProfileImage(File pickedImage, String username) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('users_profile_image')
        .child('profilePicOf:' + username + '/HisId:' + uid + '.jpg');
    await ref.putFile(pickedImage);
    final String url = await ref.getDownloadURL();
    return url;
  }

  UserData _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return UserData(
      userId: snapshot.id,
      username: data['username'],
      userProfilePicture: data['userProfilePicture'],
      dateOfCreation: data['dateOfCreation'],
      email: data['email'],
    );
  }

  Stream<UserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  //this is for fetching all the users data
/*
  List<UserData> _userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }*/
}
