import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynutrijourney/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../providers/user_provider.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  //# FUNCTION to get the current logged in user info
  Future<model.User> getUserInfo() async {
    // this is firebase user
    User loggedInUser = _firebaseauth.currentUser!;

    //getting firebase user as a snapshot
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(loggedInUser.email).get();

    // converting the snapshot to Dart model using the function inside User Model class
    return model.User.fromSnap(documentSnapshot);
  }

  //# FUNCTION to login the user
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String response = "error signin user...";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _firebaseauth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        response = "success";
      } else {
        response = "Please enter all fields";
      }
    } catch (error) {
      return error.toString();
    }
    return response;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String response = "Failed to sign up user";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        // create user in firebase authentication
        UserCredential userCredential = await _firebaseauth
            .createUserWithEmailAndPassword(email: email, password: password);

        //now we are going to create user inside the database too

        //first, we upload the image to the firebase storage, and getback the image link
        String imageLink = await uploadImageToStorage('profilePicture', file);

        //second, we create Dart model based on the data we get from signup form

        model.User _user = model.User(
          uid: userCredential.user!.uid,
          username: username,
          email: email,
          profileImage: imageLink,
        );

        //add the user into firestore DB
        await _firestore
            .collection("users")
            .doc(userCredential.user!.email)
            .set(_user.toJson());

        response = "success";
      } else {
        response = "Please Enter all the fields";
      }
    } catch (error) {
      return error.toString();
    }
    return response;
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseauth.signOut();
    Provider.of<UserProvider>(context, listen: false).clearUser();
  }
}
