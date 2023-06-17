
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String profileImage;

  const User(
      {
      required this.uid,
      required this.username,
      required this.email,
      required this.profileImage,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
      username: snapshot["username"],
      email: snapshot["email"],
      profileImage: snapshot["profileImage"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "profileImage": profileImage,
      };
}
