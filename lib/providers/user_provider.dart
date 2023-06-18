import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get getUser => _user!;
  // User? get getUser => _user;

  // Future<void> setUser() async {
  //   User user = await _authService.getUserInfo();
  //   _user = user;
  //   notifyListeners();
  // }

  Future<void> setUser() async {
    User user = await _authService.getUserInfo();

    print("CALLED REFRESH USER");
    print(user.toJson());

    _user = user;
    notifyListeners();
  }

  void clearUser() {
  _user = null;
  notifyListeners();
}

  // Future<void> retrieveUser() async {
  //   // Load the user data from Firebase.
  //   _user = await _authService.getUserInfo();
  //   // Notify the listeners that the user data has been updated.
  //   notifyListeners();
  // }
}
