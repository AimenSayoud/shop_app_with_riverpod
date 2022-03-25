import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;

  AppUser({required this.uid});

  void then(AppUser Function(AppUser? value) param0) {}
}

class UserData {
  final String email;
  final String username;
  final String userProfilePicture;
  final Timestamp dateOfCreation;
  final String userId;

  UserData(
      {required this.userId,
      required this.email,
      required this.username,
      required this.userProfilePicture,
      required this.dateOfCreation});
}
