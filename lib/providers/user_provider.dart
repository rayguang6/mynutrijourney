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

    print(user.toJson());

    _user = user;
    notifyListeners();
  }
}
