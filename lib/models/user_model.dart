import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String profileImage;
  final String uid;
  final String name;
  final String phoneNumber;
  final String emailId;

  UserModel(
      this.uid, this.name, this.phoneNumber, this.emailId, this.profileImage);

  factory UserModel.fromDocument(User user) {
    return UserModel(user.uid, user.displayName, user.phoneNumber, user.email,
        user.photoURL);
  }
}
