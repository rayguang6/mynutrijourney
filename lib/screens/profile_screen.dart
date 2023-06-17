import 'package:flutter/material.dart';
import 'package:mynutrijourney/screens/signin_screen.dart';
import 'package:mynutrijourney/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: ElevatedButton(
            child: Text('Log Out'),
            onPressed: () {
              AuthService().signOut().then((value) {
                //pop the profile screen
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (c) => SignInScreen()),
                );
              });
            }),
      )),
    );
  }
}
